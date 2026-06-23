let selectedAvatarFile = null;

async function loadProfile() {
  const profile = await request("/profile");
  const user = window.currentUser || profile;
  const avatarUrl = getAvatarUrl(profile);

  $("#profileCard").className = user.role === "admin" ? "panel admin-profile-card" : "panel campus-profile-card";
  $("#avatarPreview").src = avatarUrl;
  $("#avatarPreview").onerror = function () { handleAvatarError(this); };
  $("#profileName").textContent = profile.name || "-";
  $("#profileRole").textContent = getRoleText(profile.role);
  $("#profileUsername").textContent = profile.username || "-";
  $("#profileClass").textContent = profile.class_name || "暂无班级";
  $("#profilePhone").textContent = profile.phone || "暂无手机号";
  $("#profilePoints").textContent = profile.points ?? 0;
  $("#profileStatus").innerHTML = renderStatusBadge(profile.status);
  $("#profileStudentNo").textContent = profile.student_no || "管理员账号";
  $("#profileTasks").textContent = profile.completed_task_count ?? 0;
  $("#profileCheckins").textContent = profile.checkin_count ?? 0;
  $("#profileBadges").textContent = profile.badge_count ?? 0;

  window.currentUser = { ...window.currentUser, ...profile };
  applyAvatarToPage(avatarUrl);
}

function chooseAvatar() {
  $("#avatarInput").click();
}

function handleAvatarChange(event) {
  const file = event.target.files[0];
  if (!file) {
    return;
  }

  try {
    validateAvatarFile(file);
    selectedAvatarFile = file;
    previewAvatar(file, $("#avatarPreview"));
    $("#avatarTips").textContent = `已选择：${file.name}`;
    $("#uploadBtn").disabled = false;
  } catch (error) {
    selectedAvatarFile = null;
    event.target.value = "";
    $("#avatarTips").textContent = error.message;
    $("#uploadBtn").disabled = true;
    alert(error.message);
  }
}

async function submitAvatar() {
  if (!selectedAvatarFile) {
    alert("请先选择头像文件");
    return;
  }

  const result = await uploadAvatar(selectedAvatarFile);
  applyAvatarToPage(result.avatar_url);
  $("#avatarPreview").src = getAvatarUrl(result.avatar_url);
  $("#avatarTips").textContent = "头像上传成功，刷新页面后仍可正常显示。";
  $("#avatarInput").value = "";
  $("#uploadBtn").disabled = true;
  selectedAvatarFile = null;
}

(async function initProfilePage() {
  const user = await initLayout("个人资料");
  $("#app").innerHTML = `
    <section id="profileCard" class="panel">
      <div class="profile-layout">
        <div class="profile-avatar-block">
          <div class="${user.role === "admin" ? "admin-avatar-upload" : "campus-avatar-upload"}">
            <img id="avatarPreview" class="${user.role === "admin" ? "admin-avatar admin-avatar-xl js-current-avatar" : "campus-avatar campus-avatar-xl js-current-avatar"}" alt="头像">
          </div>
          <div class="profile-avatar-actions">
            <input id="avatarInput" type="file" accept=".jpg,.jpeg,.png,.webp" class="hidden" onchange="handleAvatarChange(event)">
            <button onclick="chooseAvatar()">选择头像</button>
            <button id="uploadBtn" class="success" onclick="submitAvatar()" disabled>确认上传</button>
            <p id="avatarTips" class="muted">支持 jpg、jpeg、png、webp，大小不超过 2MB。</p>
          </div>
        </div>
        <div class="profile-info-block">
          <div class="profile-title">
            <h2 id="profileName">-</h2>
            <span id="profileRole" class="pill">-</span>
          </div>
          <div class="profile-grid">
            <div class="profile-item"><span class="muted">用户名</span><strong id="profileUsername">-</strong></div>
            <div class="profile-item"><span class="muted">学号</span><strong id="profileStudentNo">-</strong></div>
            <div class="profile-item"><span class="muted">班级</span><strong id="profileClass">-</strong></div>
            <div class="profile-item"><span class="muted">手机号</span><strong id="profilePhone">-</strong></div>
            <div class="profile-item"><span class="muted">当前积分</span><strong id="profilePoints">0</strong></div>
            <div class="profile-item"><span class="muted">账号状态</span><strong id="profileStatus">-</strong></div>
            <div class="profile-item"><span class="muted">已完成任务</span><strong id="profileTasks">0</strong></div>
            <div class="profile-item"><span class="muted">累计签到</span><strong id="profileCheckins">0</strong></div>
            <div class="profile-item"><span class="muted">已获徽章</span><strong id="profileBadges">0</strong></div>
          </div>
        </div>
      </div>
    </section>
  `;

  await loadProfile();
})();
