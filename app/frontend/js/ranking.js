const rankingState = {
  type: "points",
  page: 1,
  pageSize: 10,
};

async function loadRanking(type = rankingState.type, page = rankingState.page) {
  rankingState.type = type;
  rankingState.page = page;

  const endpointMap = {
    points: "/ranking/points",
    class: "/ranking/class",
    today: "/ranking/today",
    tasks: "/ranking/tasks",
  };

  const query = buildQuery({
    page: rankingState.page,
    page_size: rankingState.pageSize,
    class_name: getQuery("#className"),
  });
  const data = await request(`${endpointMap[type]}?${query}`);
  const items = getPageItems(data);
  const user = window.currentUser || await getCurrentUser();
  const avatarClass = user.role === "admin" ? "admin-table-avatar" : "campus-rank-avatar";

  if (user.role === "student" && type === "points") {
    renderStudentPodium(items.slice(0, 3));
  } else {
    $("#podium").innerHTML = "";
  }

  if (type === "class") {
    renderTable("#table", [
      { title: "班级", value: "class_name" },
      { title: "总积分", value: "total_points" },
      { title: "学生数", value: "student_count" },
    ], items);
  } else if (type === "today") {
    renderTable("#table", [
      { title: "头像", value: row => renderAvatar(row, "sm", avatarClass) },
      { title: "学生", value: "name" },
      { title: "班级", value: "class_name" },
      { title: "今日积分", value: "today_points" },
    ], items);
  } else if (type === "tasks") {
    renderTable("#table", [
      { title: "头像", value: row => renderAvatar(row, "sm", avatarClass) },
      { title: "学生", value: "name" },
      { title: "班级", value: "class_name" },
      { title: "已完成任务数", value: "task_count" },
    ], items);
  } else {
    renderTable("#table", [
      { title: "头像", value: row => renderAvatar(row, "sm", avatarClass) },
      { title: "学生", value: "name" },
      { title: "班级", value: "class_name" },
      { title: "积分", value: "points" },
    ], items);
  }

  renderPagination("#pagination", data, "rankingState", "changeRankingPage");
}

function renderStudentPodium(items) {
  if (!items.length) {
    $("#podium").innerHTML = "";
    return;
  }

  $("#podium").innerHTML = `
    <div class="podium-grid">
      ${items.map((item, index) => `
        <article class="rank-podium">
          <div class="muted">TOP ${index + 1}</div>
          <div class="rank-avatar">${renderAvatar(item, "lg", "campus-rank-avatar")}</div>
          <strong>${item.points}</strong>
          <div>${escapeHtml(item.name)}</div>
          <div class="muted">${escapeHtml(item.class_name || "-")}</div>
        </article>
      `).join("")}
    </div>
  `;
}

function changeRankingPage(page) {
  loadRanking(rankingState.type, page);
}

(async function initRankingPage() {
  await initLayout("排行榜");
  $("#app").innerHTML = `
    <section class="panel">
      <div class="toolbar">
        <button onclick="loadRanking('points', 1)">总积分榜</button>
        <button onclick="loadRanking('class', 1)">班级积分榜</button>
        <button onclick="loadRanking('today', 1)">今日积分榜</button>
        <button onclick="loadRanking('tasks', 1)">任务完成榜</button>
        <input id="className" placeholder="班级筛选（可选）">
        <button onclick="loadRanking(rankingState.type, 1)">应用筛选</button>
      </div>
      <div id="podium"></div>
      <div id="table"></div>
      <div id="pagination"></div>
    </section>
  `;
  loadRanking("points");
})();
