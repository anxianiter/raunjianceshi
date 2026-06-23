const hallState = {
  page: 1,
  pageSize: 9,
};

async function loadBlindBoxSummary() {
  const today = new Date().toISOString().slice(0, 10);
  const claimData = await request("/claims/my?page=1&page_size=100");
  const todayBlindBoxCount = getPageItems(claimData).filter(
    item => item.claim_date === today && item.task_is_blind_box
  ).length;
  const remain = Math.max(0, 3 - todayBlindBoxCount);

  $("#blindBoxSummary").innerHTML = `
    <div class="checkin-board">
      <h3 class="card-title">今日任务盲盒</h3>
      <p class="muted">每天最多可以抽取 3 次校园任务盲盒，试试看今天会抽到什么挑战吧。</p>
      <div class="card-meta">
        <span class="pill">已抽取 ${todayBlindBoxCount} 次</span>
        <span class="pill">剩余 ${remain} 次</span>
      </div>
      <button class="glow-button" onclick="drawTask()" ${remain <= 0 ? "disabled" : ""}>抽取今日校园任务</button>
    </div>
  `;
}

async function loadHall(page = hallState.page) {
  hallState.page = page;
  const query = buildQuery({
    page: hallState.page,
    page_size: hallState.pageSize,
    category_id: getQuery("#categoryId"),
    difficulty: getQuery("#difficulty"),
    min_points: getQuery("#minPoints"),
    max_points: getQuery("#maxPoints"),
  });
  const data = await request(`/claims/hall?${query}`);
  const items = getPageItems(data);

  $("#hallList").innerHTML = items.length
    ? items.map(row => `
      <article class="task-card">
        <h3 class="card-title">${escapeHtml(row.title)}</h3>
        <div class="card-meta">
          <span class="pill">${escapeHtml(row.category_name)}</span>
          <span class="pill">${row.points} 积分</span>
          <span class="pill">${statusText(row.difficulty)}</span>
          <span class="pill">${row.need_review ? "需要审核" : "自动通过"}</span>
        </div>
        <p class="muted">${escapeHtml(row.description || "")}</p>
        <p class="muted">今日领取：${row.daily_claim_count}/${row.daily_limit}</p>
        ${row.can_claim
          ? `<button class="glow-button" onclick="claimTask(${row.id})">领取任务</button>`
          : `<div class="status-badge status-cancelled">今日不可领取</div>`}
      </article>
    `).join("")
    : `<div class="empty-state">暂无符合条件的任务，换个筛选条件试试吧。</div>`;

  renderPagination("#pagination", data, "hallState", "loadHall");
}

async function claimTask(id) {
  await request("/claims/claim", { method: "POST", body: { task_id: id } });
  alert("领取成功，请前往“我的任务”页面提交打卡说明。");
  await loadBlindBoxSummary();
  loadHall(hallState.page);
}

async function drawTask() {
  const data = await request("/claims/draw", { method: "POST" });
  alert(`盲盒抽取成功：${data.task_title || "新任务已经加入我的任务列表"}`);
  await loadBlindBoxSummary();
  loadHall(1);
}

(async function initTaskHallPage() {
  await initLayout("任务大厅");
  $("#app").innerHTML = `
    <section class="panel campus-hero">
      <div class="page-hero">
        <div>
          <h2>校园任务大厅</h2>
          <p class="muted">在这里领取日常学习任务，也可以试试今天的任务盲盒。</p>
        </div>
      </div>
      <div id="blindBoxSummary"></div>
    </section>
    <section class="panel">
      <div class="toolbar">
        <input id="categoryId" placeholder="分类 ID">
        <select id="difficulty">
          <option value="">全部难度</option>
          <option value="easy">easy</option>
          <option value="normal">normal</option>
          <option value="hard">hard</option>
        </select>
        <input id="minPoints" placeholder="最低积分">
        <input id="maxPoints" placeholder="最高积分">
        <button onclick="loadHall(1)">查询</button>
        <button onclick="$('#categoryId').value=''; $('#difficulty').value=''; $('#minPoints').value=''; $('#maxPoints').value=''; loadHall(1)">重置</button>
      </div>
      <div id="hallList" class="card-grid"></div>
      <div id="pagination"></div>
    </section>
  `;

  await loadBlindBoxSummary();
  loadHall();
})();
