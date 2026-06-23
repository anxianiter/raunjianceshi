const challengeState = {
  page: 1,
  pageSize: 8,
};

const challengeRecordState = {
  page: 1,
  pageSize: 8,
};

async function loadChallenges(page = challengeState.page) {
  challengeState.page = page;
  const query = buildQuery({
    page: challengeState.page,
    page_size: challengeState.pageSize,
    keyword: getQuery("#keyword"),
    status: getQuery("#status"),
    start_date: getQuery("#startDate"),
    end_date: getQuery("#endDate"),
  });
  const data = await request(`/challenges?${query}`);
  const items = getPageItems(data);
  const user = await getCurrentUser();

  if (user.role === "student") {
    $("#challengeList").innerHTML = items.length
      ? items.map(row => `
        <article class="challenge-card">
          <h3 class="card-title">${escapeHtml(row.title)}</h3>
          <p class="muted">${escapeHtml(row.description || "")}</p>
          <div class="card-meta">
            <span class="pill">奖励 ${row.reward_points} 分</span>
            <span class="pill">开始 ${formatDateTime(row.start_time)}</span>
            <span class="pill">结束 ${formatDateTime(row.end_time)}</span>
          </div>
          <button class="glow-button" onclick="joinChallenge(${row.id})">报名挑战赛</button>
        </article>
      `).join("")
      : `<div class="empty-state">当前没有可参与的挑战赛。</div>`;
  } else {
    renderTable("#challengeTable", [
      { title: "标题", value: "title" },
      { title: "奖励积分", value: "reward_points" },
      { title: "开始时间", value: row => formatDateTime(row.start_time) },
      { title: "结束时间", value: row => formatDateTime(row.end_time) },
      { title: "状态", value: row => renderStatusBadge(row.status) },
    ], items, row => `
      <button onclick="toggleChallenge(${row.id}, '${row.status === "active" ? "disabled" : "active"}')">${row.status === "active" ? "禁用" : "启用"}</button>
    `);
  }

  renderPagination("#challengePagination", data, "challengeState", "loadChallenges");
}

async function loadChallengeRecords(page = challengeRecordState.page) {
  challengeRecordState.page = page;
  const query = buildQuery({
    page: challengeRecordState.page,
    page_size: challengeRecordState.pageSize,
    keyword: getQuery("#recordKeyword"),
    class_name: getQuery("#recordClassName"),
    status: getQuery("#recordStatus"),
  });
  const data = await request(`/challenges/records?${query}`);
  renderTable("#recordTable", [
    { title: "学生", value: "user_name" },
    { title: "班级", value: "class_name" },
    { title: "挑战赛", value: "challenge_title" },
    { title: "提交说明", value: row => row.submit_text || "-" },
    { title: "状态", value: row => renderStatusBadge(row.status) },
  ], getPageItems(data), row => row.status === "submitted" ? `
    <button class="success" onclick="approveChallenge(${row.id})">通过</button>
    <button class="danger" onclick="rejectChallenge(${row.id})">驳回</button>
  ` : "");
  renderPagination("#recordPagination", data, "challengeRecordState", "loadChallengeRecords");
}

async function loadMyChallenges() {
  const data = await request("/challenges/my");
  renderTable("#myChallengeTable", [
    { title: "挑战赛", value: "challenge_title" },
    { title: "奖励积分", value: "reward_points" },
    { title: "状态", value: row => renderStatusBadge(row.status) },
    { title: "审核意见", value: row => row.review_text || "-" },
  ], data, row => (row.status === "joined" || row.status === "rejected") ? `
    <button onclick="submitChallenge(${row.id})">提交成果</button>
  ` : "");
}

async function addChallenge() {
  const title = prompt("请输入挑战赛标题");
  if (!title) return;
  const description = prompt("请输入挑战赛说明", "完成挑战后提交成果。");
  const rewardPoints = prompt("请输入奖励积分", "15");
  const startTime = prompt("请输入开始时间", "2026-05-28 00:00:00");
  const endTime = prompt("请输入结束时间", "2026-06-10 23:59:59");
  await request("/challenges", {
    method: "POST",
    body: {
      title,
      description,
      reward_points: rewardPoints,
      start_time: startTime,
      end_time: endTime,
    },
  });
  loadChallenges(1);
}

async function toggleChallenge(id, status) {
  await request(`/challenges/${id}/status`, { method: "PATCH", body: { status } });
  loadChallenges(challengeState.page);
}

async function joinChallenge(id) {
  await request(`/challenges/${id}/join`, { method: "POST" });
  alert("报名成功，请在“我的挑战赛记录”中提交成果。");
  loadChallenges(challengeState.page);
  loadMyChallenges();
}

async function submitChallenge(id) {
  const submitText = prompt("请输入挑战赛完成说明，至少 10 个字");
  if (!submitText) return;
  await request(`/challenges/records/${id}/submit`, {
    method: "POST",
    body: { submit_text: submitText },
  });
  loadMyChallenges();
}

async function approveChallenge(id) {
  await request(`/challenges/records/${id}/approve`, {
    method: "POST",
    body: { review_text: "挑战赛审核通过" },
  });
  loadChallengeRecords(challengeRecordState.page);
}

async function rejectChallenge(id) {
  const reviewText = prompt("请输入驳回原因", "请补充更详细的完成说明");
  if (!reviewText) return;
  await request(`/challenges/records/${id}/reject`, {
    method: "POST",
    body: { review_text: reviewText },
  });
  loadChallengeRecords(challengeRecordState.page);
}

(async function initChallengePage() {
  const user = await initLayout("挑战赛");
  if (user.role === "student") {
    $("#app").innerHTML = `
      <section class="panel campus-hero">
        <div class="page-hero">
          <div>
            <h2>进行中的挑战赛</h2>
            <p class="muted">报名挑战、提交成果、通过审核后获得积分奖励。</p>
          </div>
        </div>
        <div id="challengeList" class="card-grid"></div>
        <div id="challengePagination"></div>
      </section>
      <section class="panel">
        <h2>我的挑战赛记录</h2>
        <div id="myChallengeTable"></div>
      </section>
    `;
    loadChallenges();
    loadMyChallenges();
    return;
  }

  $("#app").innerHTML = `
    <section class="panel">
      <div class="toolbar">
        <input id="keyword" placeholder="挑战赛关键词">
        <select id="status">
          <option value="">全部状态</option>
          <option value="active">active</option>
          <option value="disabled">disabled</option>
        </select>
        <input id="startDate" type="date">
        <input id="endDate" type="date">
        <button onclick="loadChallenges(1)">查询</button>
        <button onclick="$('#keyword').value=''; $('#status').value=''; $('#startDate').value=''; $('#endDate').value=''; loadChallenges(1)">重置</button>
        <button class="success" onclick="addChallenge()">发布挑战赛</button>
      </div>
      <div id="challengeTable"></div>
      <div id="challengePagination"></div>
    </section>
    <section class="panel">
      <h2>挑战赛提交记录</h2>
      <div class="toolbar">
        <input id="recordKeyword" placeholder="学生关键词">
        <input id="recordClassName" placeholder="班级">
        <select id="recordStatus">
          <option value="">全部状态</option>
          <option value="joined">joined</option>
          <option value="submitted">submitted</option>
          <option value="approved">approved</option>
          <option value="rejected">rejected</option>
        </select>
        <button onclick="loadChallengeRecords(1)">查询记录</button>
      </div>
      <div id="recordTable"></div>
      <div id="recordPagination"></div>
    </section>
  `;

  loadChallenges();
  loadChallengeRecords();
})();
