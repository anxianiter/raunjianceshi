const taskState = {
  page: 1,
  pageSize: 10,
};

async function loadTasks(page = taskState.page) {
  taskState.page = page;
  const query = buildQuery({
    page: taskState.page,
    page_size: taskState.pageSize,
    keyword: getQuery("#keyword"),
    category_id: getQuery("#categoryId"),
    difficulty: getQuery("#difficulty"),
    status: getQuery("#status"),
  });
  const data = await request(`/tasks?${query}`);
  renderTable("#table", [
    { title: "任务标题", value: "title" },
    { title: "分类", value: "category_name" },
    { title: "积分", value: "points" },
    { title: "难度", value: row => renderStatusBadge(row.difficulty) },
    { title: "盲盒任务", value: row => row.is_blind_box ? "是" : "否" },
    { title: "需要审核", value: row => row.need_review ? "是" : "否" },
    { title: "状态", value: row => renderStatusBadge(row.status) },
  ], getPageItems(data), row => `
    <button onclick="editTask(${row.id})">编辑</button>
    <button onclick="toggleTask(${row.id}, '${row.status === "active" ? "disabled" : "active"}')">${row.status === "active" ? "禁用" : "启用"}</button>
  `);
  renderPagination("#pagination", data, "taskState", "loadTasks");
}

async function addTask() {
  const categoryId = prompt("请输入分类 ID", "1");
  const title = prompt("请输入任务标题");
  if (!title) return;
  const description = prompt("请输入任务说明", "完成后提交打卡说明。");
  const points = prompt("请输入任务积分", "8");
  const difficulty = prompt("请输入难度 easy / normal / hard", "easy");
  const dailyLimit = prompt("请输入每日领取上限", "20");
  const isBlindBox = confirm("是否允许加入任务盲盒？");
  const needReview = confirm("是否需要管理员审核？");

  await request("/tasks", {
    method: "POST",
    body: {
      category_id: categoryId,
      title,
      description,
      points,
      difficulty,
      daily_limit: dailyLimit,
      is_blind_box: isBlindBox,
      need_review: needReview,
    },
  });
  loadTasks(1);
}

async function editTask(id) {
  const title = prompt("请输入新的任务标题");
  if (!title) return;
  const points = prompt("请输入新的积分", "10");
  const difficulty = prompt("请输入难度 easy / normal / hard", "normal");
  const status = prompt("请输入状态 active / disabled", "active");
  await request(`/tasks/${id}`, {
    method: "PUT",
    body: { title, points, difficulty, status },
  });
  loadTasks(taskState.page);
}

async function toggleTask(id, status) {
  const actionText = status === "disabled" ? "禁用" : "启用";
  if (!confirm(`确定要${actionText}这个任务吗？`)) return;
  await request(`/tasks/${id}/status`, { method: "PATCH", body: { status } });
  loadTasks(taskState.page);
}

(async function initTaskPage() {
  await initLayout("任务管理");
  $("#app").innerHTML = `
    <section class="panel">
      <div class="toolbar">
        <input id="keyword" placeholder="任务标题关键词">
        <input id="categoryId" placeholder="分类 ID">
        <select id="difficulty">
          <option value="">全部难度</option>
          <option value="easy">easy</option>
          <option value="normal">normal</option>
          <option value="hard">hard</option>
        </select>
        <select id="status">
          <option value="">全部状态</option>
          <option value="active">active</option>
          <option value="disabled">disabled</option>
        </select>
        <button onclick="loadTasks(1)">查询</button>
        <button onclick="$('#keyword').value=''; $('#categoryId').value=''; $('#difficulty').value=''; $('#status').value=''; loadTasks(1)">重置</button>
        <button class="success" onclick="addTask()">新增任务</button>
      </div>
      <div id="table"></div>
      <div id="pagination"></div>
    </section>
  `;
  loadTasks();
})();
