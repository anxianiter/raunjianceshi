const checkinState = {
  page: 1,
  pageSize: 10,
};

async function doCheckin() {
  const data = await request("/checkins/checkin", { method: "POST" });
  alert(`签到成功，获得 ${data.base_points + data.bonus_points} 积分`);
  loadMyCheckins();
}

async function loadMyCheckins() {
  const data = await request("/checkins/my");
  const total = data.length;
  const today = new Date().toISOString().slice(0, 10);
  const todayRecord = data.find(item => item.checkin_date === today);
  const continuous = data[0]?.continuous_days || 0;

  $("#studentCheckinBoard").innerHTML = `
    <div class="checkin-board">
      <h3 class="card-title">今日校园打卡</h3>
      <p class="muted">每日签到基础奖励 2 分，连续签到 3 天奖励 3 分，连续签到 7 天奖励 10 分。</p>
      <div class="card-meta">
        <span class="pill">累计签到 ${total} 次</span>
        <span class="pill">连续签到 ${continuous} 天</span>
        <span class="pill">${todayRecord ? "今天已签到" : "今天未签到"}</span>
      </div>
      <button class="glow-button" onclick="doCheckin()" ${todayRecord ? "disabled" : ""}>${todayRecord ? "今天已完成签到" : "立即签到"}</button>
    </div>
  `;

  renderTable("#studentCheckinList", [
    { title: "签到日期", value: "checkin_date" },
    { title: "基础积分", value: "base_points" },
    { title: "奖励积分", value: "bonus_points" },
    { title: "连续天数", value: "continuous_days" },
  ], data);
}

async function loadAllCheckins(page = checkinState.page) {
  checkinState.page = page;
  const query = buildQuery({
    page: checkinState.page,
    page_size: checkinState.pageSize,
    keyword: getQuery("#keyword"),
    class_name: getQuery("#className"),
    start_date: getQuery("#startDate"),
    end_date: getQuery("#endDate"),
  });
  const data = await request(`/checkins/all?${query}`);
  renderTable("#table", [
    { title: "学生", value: "user_name" },
    { title: "班级", value: "class_name" },
    { title: "签到日期", value: "checkin_date" },
    { title: "基础积分", value: "base_points" },
    { title: "奖励积分", value: "bonus_points" },
    { title: "连续天数", value: "continuous_days" },
  ], getPageItems(data));
  renderPagination("#pagination", data, "checkinState", "loadAllCheckins");
}

(async function initCheckinPage() {
  const user = await initLayout("签到记录");

  if (user.role === "student") {
    $("#app").innerHTML = `
      <section class="panel campus-hero">
        <div id="studentCheckinBoard"></div>
      </section>
      <section class="panel">
        <h2>我的签到记录</h2>
        <div id="studentCheckinList"></div>
      </section>
    `;
    loadMyCheckins();
    return;
  }

  $("#app").innerHTML = `
    <section class="panel">
      <div class="toolbar">
        <input id="keyword" placeholder="学生关键词">
        <input id="className" placeholder="班级">
        <input id="startDate" type="date">
        <input id="endDate" type="date">
        <button onclick="loadAllCheckins(1)">查询</button>
        <button onclick="$('#keyword').value=''; $('#className').value=''; $('#startDate').value=''; $('#endDate').value=''; loadAllCheckins(1)">重置</button>
      </div>
      <div id="table"></div>
      <div id="pagination"></div>
    </section>
  `;
  loadAllCheckins();
})();
