(async function initBadgePage() {
  const user = await initLayout("成就徽章");
  $("#app").innerHTML = `
    <section class="panel">
      ${user.role === "admin" ? `<div class="toolbar"><button class="success" onclick="addBadge()">新增徽章</button></div>` : ""}
      <div id="badgeList" class="${user.role === "student" ? "card-grid" : ""}"></div>
    </section>
    ${user.role === "student" ? `
      <section class="panel">
        <h2>我已获得的徽章</h2>
        <div id="myBadges"></div>
      </section>
    ` : ""}
  `;
  loadBadges(user);
})();

async function loadBadges(user) {
  const data = await request("/badges");

  if (user.role === "admin") {
    renderTable("#badgeList", [
      { title: "徽章名称", value: "name" },
      { title: "说明", value: "description" },
      { title: "获得条件", value: row => `${row.condition_type}: ${row.condition_value}` },
      { title: "奖励积分", value: "reward_points" },
      { title: "状态", value: row => renderStatusBadge(row.status) },
    ], data, row => `
      <button onclick="toggleBadge(${row.id}, '${row.status === "active" ? "disabled" : "active"}')">${row.status === "active" ? "禁用" : "启用"}</button>
    `);
    return;
  }

  const mine = await request("/badges/my");
  const earnedBadgeIds = new Set(mine.map(item => item.badge_id));

  $("#badgeList").innerHTML = data.length
    ? data.map(item => `
      <article class="student-card ${earnedBadgeIds.has(item.id) ? "badge-earned" : "badge-locked"}">
        <h3 class="card-title">${escapeHtml(item.name)}</h3>
        <p class="muted">${escapeHtml(item.description)}</p>
        <div class="card-meta">
          <span class="pill">${escapeHtml(item.condition_type)}</span>
          <span class="pill">条件值 ${escapeHtml(item.condition_value)}</span>
          <span class="pill">奖励 ${item.reward_points} 分</span>
        </div>
      </article>
    `).join("")
    : `<div class="empty-state">你还没有可查看的徽章。</div>`;

  renderTable("#myBadges", [
    { title: "徽章名称", value: "badge_name" },
    { title: "奖励积分", value: "reward_points" },
    { title: "获得时间", value: row => formatDateTime(row.awarded_at) },
  ], mine);
}

async function addBadge() {
  const name = prompt("请输入徽章名称");
  if (!name) return;
  const description = prompt("请输入徽章说明", "");
  const conditionType = prompt("请输入条件类型", "task_approved_total");
  const conditionValue = prompt("请输入条件值", "3");
  const rewardPoints = prompt("请输入奖励积分", "5");
  await request("/badges", {
    method: "POST",
    body: {
      name,
      description,
      condition_type: conditionType,
      condition_value: conditionValue,
      reward_points: rewardPoints,
    },
  });
  location.reload();
}

async function toggleBadge(id, status) {
  await request(`/badges/${id}/status`, { method: "PATCH", body: { status } });
  location.reload();
}
