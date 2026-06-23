const userState = {
  page: 1,
  pageSize: 10,
};

async function loadUsers(page = userState.page) {
  userState.page = page;
  const query = buildQuery({
    page: userState.page,
    page_size: userState.pageSize,
    keyword: getQuery("#keyword"),
    class_name: getQuery("#className"),
    status: getQuery("#status"),
  });
  const data = await request(`/users?${query}`);
  renderTable("#table", [
    { title: "头像", value: row => renderAvatar(row, "sm", "admin-table-avatar") },
    { title: "学号", value: row => row.student_no || "-" },
    { title: "姓名", value: "name" },
    { title: "班级", value: row => row.class_name || "-" },
    { title: "用户名", value: "username" },
    { title: "手机号", value: row => row.phone || "-" },
    { title: "积分", value: "points" },
    { title: "状态", value: row => renderStatusBadge(row.status) },
  ], getPageItems(data), row => `
    <button onclick="viewUser(${row.id})">详情</button>
    <button onclick="editUser(${row.id})">编辑</button>
    <button onclick="toggleUser(${row.id}, '${row.status === "active" ? "disabled" : "active"}')">${row.status === "active" ? "禁用" : "启用"}</button>
    <button onclick="resetPassword(${row.id})">重置密码</button>
  `);
  renderPagination("#pagination", data, "userState", "loadUsers");
}

async function addUser() {
  const username = prompt("请输入用户名，例如 stu021");
  if (!username) return;
  const studentNo = prompt("请输入学号，例如 S2026021");
  if (!studentNo) return;
  const name = prompt("请输入姓名");
  if (!name) return;
  const className = prompt("请输入班级", "Python一班");
  const phone = prompt("请输入手机号", "");
  await request("/users", {
    method: "POST",
    body: {
      username,
      student_no: studentNo,
      name,
      class_name: className,
      phone,
      password: "123456",
    },
  });
  loadUsers(1);
}

async function editUser(id) {
  const name = prompt("请输入新的姓名");
  if (!name) return;
  const className = prompt("请输入新的班级", "Python一班");
  const phone = prompt("请输入手机号", "");
  await request(`/users/${id}`, {
    method: "PUT",
    body: { name, class_name: className, phone },
  });
  loadUsers(userState.page);
}

async function toggleUser(id, status) {
  const actionText = status === "disabled" ? "禁用" : "启用";
  if (!confirm(`确定要${actionText}这个学生账号吗？`)) return;
  await request(`/users/${id}/status`, { method: "PATCH", body: { status } });
  loadUsers(userState.page);
}

async function resetPassword(id) {
  if (!confirm("确定要将密码重置为 123456 吗？")) return;
  await request(`/users/${id}/reset-password`, {
    method: "PATCH",
    body: { password: "123456" },
  });
  alert("密码已重置为 123456");
}

async function viewUser(id) {
  const data = await request(`/users/${id}`);
  $("#detail").innerHTML = `
    <section class="panel admin-profile-card">
      <div class="profile-layout">
        <div class="profile-avatar-block">
          ${renderAvatar(data, "xl", "admin-avatar")}
        </div>
        <div class="profile-info-block">
          <div class="profile-title">
            <h2>${escapeHtml(data.name)}</h2>
            ${renderStatusBadge(data.status)}
          </div>
          <div class="profile-grid">
            <div class="profile-item"><span class="muted">学号</span><strong>${escapeHtml(data.student_no || "-")}</strong></div>
            <div class="profile-item"><span class="muted">用户名</span><strong>${escapeHtml(data.username)}</strong></div>
            <div class="profile-item"><span class="muted">班级</span><strong>${escapeHtml(data.class_name || "-")}</strong></div>
            <div class="profile-item"><span class="muted">手机号</span><strong>${escapeHtml(data.phone || "-")}</strong></div>
            <div class="profile-item"><span class="muted">当前积分</span><strong>${data.points}</strong></div>
            <div class="profile-item"><span class="muted">连续签到</span><strong>${data.continuous_checkin_days} 天</strong></div>
            <div class="profile-item"><span class="muted">已完成任务</span><strong>${data.approved_task_count}</strong></div>
            <div class="profile-item"><span class="muted">待审核任务</span><strong>${data.submitted_task_count}</strong></div>
            <div class="profile-item"><span class="muted">累计签到</span><strong>${data.checkin_count}</strong></div>
            <div class="profile-item"><span class="muted">已获徽章</span><strong>${data.badge_count}</strong></div>
          </div>
        </div>
      </div>
    </section>
  `;
}

(async function initUserPage() {
  await initLayout("学生管理");
  $("#app").innerHTML = `
    <section class="panel">
      <div class="toolbar">
        <input id="keyword" placeholder="学号 / 姓名 / 用户名 / 手机号">
        <input id="className" placeholder="班级">
        <select id="status">
          <option value="">全部状态</option>
          <option value="active">启用</option>
          <option value="disabled">禁用</option>
        </select>
        <button onclick="loadUsers(1)">查询</button>
        <button onclick="$('#keyword').value=''; $('#className').value=''; $('#status').value=''; loadUsers(1)">重置</button>
        <button class="success" onclick="addUser()">新增学生</button>
      </div>
      <div id="table"></div>
      <div id="pagination"></div>
    </section>
    <div id="detail"></div>
  `;
  loadUsers();
})();
