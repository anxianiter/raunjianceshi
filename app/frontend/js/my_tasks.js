const myTaskState = {
  page: 1,
  pageSize: 8,
};

async function loadMyTasks(page = myTaskState.page) {
  myTaskState.page = page;
  const query = buildQuery({
    page: myTaskState.page,
    page_size: myTaskState.pageSize,
    status: getQuery("#status"),
  });
  const data = await request(`/claims/my?${query}`);
  const items = getPageItems(data);

  $("#taskList").innerHTML = items.length
    ? items.map(row => `
      <article class="task-card">
        <h3 class="card-title">${escapeHtml(row.task_title)}</h3>
        <div class="card-meta">
          <span class="pill">${row.task_points} 积分</span>
          <span class="pill">${escapeHtml(row.task_category_name || "任务")}</span>
          <span class="pill">${statusText(row.task_difficulty)}</span>
          <span class="status-badge status-${escapeHtml(row.status)}">${statusText(row.status)}</span>
        </div>
        <p class="muted">领取日期：${escapeHtml(row.claim_date || "-")}</p>
        <p class="muted">审核意见：${escapeHtml(row.review_text || "暂无")}</p>
        <div class="toolbar">
          ${(row.status === "claimed" || row.status === "rejected") ? `<button onclick="submitTask(${row.id})">提交打卡</button>` : ""}
          ${row.status === "claimed" ? `<button class="danger" onclick="cancelTask(${row.id})">取消任务</button>` : ""}
        </div>
      </article>
    `).join("")
    : `<div class="empty-state">暂无任务记录，先去任务大厅看看吧。</div>`;

  renderPagination("#pagination", data, "myTaskState", "loadMyTasks");
}

async function submitTask(id) {
  const submitText = prompt("请输入打卡说明，至少 10 个字");
  if (!submitText) return;
  await request(`/claims/${id}/submit`, { method: "POST", body: { submit_text: submitText } });
  loadMyTasks(myTaskState.page);
}

async function cancelTask(id) {
  if (!confirm("确定要取消这个未提交的任务吗？")) return;
  await request(`/claims/${id}/cancel`, { method: "POST" });
  loadMyTasks(myTaskState.page);
}

(async function initMyTaskPage() {
  await initLayout("我的任务");
  $("#app").innerHTML = `
    <section class="panel">
      <div class="toolbar">
        <select id="status">
          <option value="">全部状态</option>
          <option value="claimed">未提交</option>
          <option value="submitted">审核中</option>
          <option value="approved">已完成</option>
          <option value="rejected">已驳回</option>
          <option value="cancelled">已取消</option>
        </select>
        <button onclick="loadMyTasks(1)">筛选</button>
      </div>
      <div id="taskList" class="card-grid"></div>
      <div id="pagination"></div>
    </section>
  `;
  loadMyTasks();
})();
