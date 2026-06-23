(async function initDashboardPage() {
  const user = await initLayout("首页");
  const app = $("#app");

  if (user.role === "admin") {
    const data = await request("/dashboard/admin");
    app.innerHTML = `
      <section class="panel admin-profile-card">
        <div class="profile-layout">
          <div class="profile-avatar-block">
            ${renderAvatar(user, "xl", "admin-avatar js-current-avatar")}
          </div>
          <div class="profile-info-block">
            <h2>欢迎回来，${escapeHtml(user.name)}</h2>
            <p class="muted">今天也来维护一下校园任务平台的数据和审核进度吧。</p>
            <div class="profile-grid">
              <div class="profile-item"><span class="muted">角色</span><strong>${escapeHtml(getRoleText(user.role))}</strong></div>
              <div class="profile-item"><span class="muted">用户名</span><strong>${escapeHtml(user.username)}</strong></div>
              <div class="profile-item"><span class="muted">当前积分</span><strong>${user.points || 0}</strong></div>
              <div class="profile-item"><span class="muted">快捷入口</span><strong><a href="profile.html">修改头像 / 资料</a></strong></div>
            </div>
          </div>
        </div>
      </section>
      <section class="panel">
        <div id="stats"></div>
      </section>
      <section class="panel">
        <h2>积分排行榜 Top 10</h2>
        <div id="top"></div>
      </section>
      <section class="panel">
        <h2>班级积分排行榜</h2>
        <div id="classRanking"></div>
      </section>
      <section class="panel">
        <h2>最近任务提交</h2>
        <div id="recentClaims"></div>
      </section>
      <section class="panel">
        <h2>最近积分流水</h2>
        <div id="recentLogs"></div>
      </section>
    `;

    renderStats("#stats", [
      { label: "学生总数", value: data.student_total },
      { label: "任务总数", value: data.task_total },
      { label: "今日签到人数", value: data.today_checkin_count },
      { label: "今日领取任务数", value: data.today_claim_count },
      { label: "待审核任务数", value: data.pending_review_count },
      { label: "已完成任务数", value: data.completed_task_count },
      { label: "挑战赛数量", value: data.challenge_total },
      { label: "兑换订单数量", value: data.reward_order_total },
    ]);

    renderTable("#top", [
      { title: "头像", value: row => renderAvatar(row, "sm", "admin-table-avatar") },
      { title: "姓名", value: "name" },
      { title: "班级", value: row => row.class_name || "-" },
      { title: "积分", value: "points" },
    ], data.top_points || []);

    renderTable("#classRanking", [
      { title: "班级", value: "class_name" },
      { title: "总积分", value: "total_points" },
      { title: "学生数", value: "student_count" },
    ], data.class_ranking || []);

    renderTable("#recentClaims", [
      { title: "学生", value: "user_name" },
      { title: "任务", value: "task_title" },
      { title: "状态", value: row => renderStatusBadge(row.status) },
      { title: "更新时间", value: row => formatDateTime(row.updated_at) },
    ], data.recent_claims || []);

    renderTable("#recentLogs", [
      { title: "学生", value: "user_name" },
      { title: "类型", value: "source_type" },
      { title: "积分变化", value: row => `<span class="${row.change_points >= 0 ? "points-positive" : "points-negative"}">${row.change_points > 0 ? "+" : ""}${row.change_points}</span>` },
      { title: "原因", value: row => row.reason || "-" },
      { title: "时间", value: row => formatDateTime(row.created_at) },
    ], data.recent_point_logs || []);
    return;
  }

  const data = await request("/dashboard/student");
  app.innerHTML = `
    <section class="panel campus-hero">
      <div class="page-hero">
        <div>
          <h2>欢迎回来，${escapeHtml(user.name)}</h2>
          <p class="muted">今天也要完成校园任务哦，继续收集积分、徽章和成长记录。</p>
        </div>
      </div>
      <div class="profile-layout campus-profile-card">
        <div class="profile-avatar-block">
          ${renderAvatar(user, "xl", "campus-avatar js-current-avatar")}
        </div>
        <div class="profile-info-block">
          <div class="profile-title">
            <h3>${escapeHtml(user.name)}</h3>
            <span class="pill">${escapeHtml(user.class_name || "校园成长中心")}</span>
          </div>
          <p class="muted">去完成今天的签到和任务，向班级排行榜前列冲刺吧。</p>
          <div class="profile-grid">
            <div class="profile-item"><span class="muted">当前积分</span><strong>${data.my_points}</strong></div>
            <div class="profile-item"><span class="muted">我的排名</span><strong>第 ${data.rank} 名</strong></div>
            <div class="profile-item"><span class="muted">今日签到</span><strong>${data.checked_in_today ? "已签到" : "未签到"}</strong></div>
            <div class="profile-item"><span class="muted">连续签到</span><strong>${data.continuous_checkin_days} 天</strong></div>
          </div>
        </div>
      </div>
      <div id="stats"></div>
      <div class="campus-action-grid">
        <a class="campus-action-card" href="checkins.html">
          <strong>去签到</strong>
          <span class="muted">完成每日打卡，获得基础积分</span>
        </a>
        <a class="campus-action-card" href="task_hall.html">
          <strong>去任务大厅</strong>
          <span class="muted">领取今天的学习任务和盲盒任务</span>
        </a>
        <a class="campus-action-card" href="my_tasks.html">
          <strong>我的任务</strong>
          <span class="muted">查看已领取任务和提交状态</span>
        </a>
        <a class="campus-action-card" href="ranking.html">
          <strong>查看排行榜</strong>
          <span class="muted">看看你在班级中的成长排名</span>
        </a>
      </div>
    </section>
    <section class="panel">
      <h2>推荐任务</h2>
      <div id="tasks" class="card-grid"></div>
    </section>
    <section class="panel">
      <h2>最新公告</h2>
      <div id="news" class="card-grid"></div>
    </section>
  `;

  renderStats("#stats", [
    { label: "当前积分", value: data.my_points },
    { label: "今日签到状态", value: data.checked_in_today ? "已签到" : "未签到" },
    { label: "连续签到天数", value: data.continuous_checkin_days },
    { label: "已完成任务", value: data.completed_task_count },
    { label: "待审核任务", value: data.pending_task_count },
    { label: "我的徽章", value: data.badge_count },
    { label: "当前排名", value: data.rank },
    { label: "兑换记录", value: data.order_count },
  ]);

  const tasks = data.recommend_tasks || [];
  $("#tasks").innerHTML = tasks.length
    ? tasks.map(item => `
      <article class="task-card">
        <h3 class="card-title">${escapeHtml(item.title)}</h3>
        <div class="card-meta">
          <span class="pill">${escapeHtml(item.category_name || "任务")}</span>
          <span class="pill">${item.points} 积分</span>
          <span class="pill">${statusText(item.difficulty)}</span>
        </div>
        <p class="muted">${escapeHtml(item.description || "完成任务即可获得成长积分。")}</p>
        <button class="glow-button" onclick="location.href='task_hall.html'">前往领取</button>
      </article>
    `).join("")
    : `<div class="empty-state">暂无推荐任务，先去任务大厅看看吧。</div>`;

  const news = data.latest_announcements || [];
  $("#news").innerHTML = news.length
    ? news.map(item => `
      <article class="announcement-card">
        <h3 class="card-title">${escapeHtml(item.title)}</h3>
        <p class="muted">${formatDateTime(item.created_at)}</p>
      </article>
    `).join("")
    : `<div class="empty-state">今天还没有新的公告通知。</div>`;
})();
