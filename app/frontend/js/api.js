const API_BASE = "http://127.0.0.1:5000/api";
const DEFAULT_AVATAR =
  "data:image/svg+xml;utf8," +
  "%3Csvg xmlns='http://www.w3.org/2000/svg' width='120' height='120' viewBox='0 0 120 120'%3E" +
  "%3Crect width='120' height='120' rx='60' fill='%23EAF3FF'/%3E" +
  "%3Ccircle cx='60' cy='42' r='24' fill='%233B82F6'/%3E" +
  "%3Cpath d='M26 95c9-15 21-23 34-23s25 8 34 23' fill='%2393C5FD'/%3E" +
  "%3C/svg%3E";
const AVATAR_MAX_SIZE = 2 * 1024 * 1024;
const AVATAR_EXTENSIONS = ["jpg", "jpeg", "png", "webp"];

window.currentUser = null;

async function request(path, options = {}) {
  const body = options.body;
  const isFormData = body instanceof FormData;
  const headers = { ...(options.headers || {}) };

  if (!isFormData && !headers["Content-Type"]) {
    headers["Content-Type"] = "application/json";
  }

  const config = {
    method: options.method || "GET",
    credentials: "include",
    headers,
  };

  if (body) {
    config.body = isFormData ? body : JSON.stringify(body);
  }

  const response = await fetch(API_BASE + path, config);
  const result = await response.json();

  if (result.code === 401) {
    location.href = "login.html";
    return null;
  }

  if (result.code !== 200) {
    alert(result.message || "请求失败");
    throw new Error(result.message || "请求失败");
  }

  return result.data;
}

function $(selector) {
  return document.querySelector(selector);
}

function $all(selector) {
  return Array.from(document.querySelectorAll(selector));
}

function getQuery(selector) {
  const element = $(selector);
  return element ? element.value.trim() : "";
}

function escapeHtml(value) {
  return String(value ?? "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#39;");
}

function buildQuery(params = {}) {
  const query = new URLSearchParams();
  Object.entries(params).forEach(([key, value]) => {
    if (value !== undefined && value !== null && String(value).trim() !== "") {
      query.set(key, value);
    }
  });
  return query.toString();
}

function getPageItems(data) {
  return Array.isArray(data) ? data : (data.items || []);
}

function getPagination(data) {
  if (!data || Array.isArray(data)) {
    const count = Array.isArray(data) ? data.length : 0;
    return {
      page: 1,
      page_size: count || 10,
      total: count,
      pages: count > 0 ? 1 : 0,
      has_prev: false,
      has_next: false,
    };
  }

  return data.pagination || {
    page: 1,
    page_size: 10,
    total: getPageItems(data).length,
    pages: 1,
    has_prev: false,
    has_next: false,
  };
}

function handleAvatarError(img) {
  img.onerror = null;
  img.src = DEFAULT_AVATAR;
}

function getAvatarUrl(source) {
  const url = typeof source === "string" ? source : source?.avatar_url;
  if (!url) {
    return DEFAULT_AVATAR;
  }
  if (url.startsWith("data:") || url.startsWith("http://") || url.startsWith("https://") || url.startsWith("/")) {
    return url;
  }
  return `/${url}`;
}

function renderAvatar(source, size = "md", extraClass = "") {
  const sizeClassMap = {
    sm: "avatar-sm",
    md: "avatar-md",
    lg: "avatar-lg",
    xl: "avatar-xl",
  };
  const className = ["avatar", sizeClassMap[size] || "avatar-md", extraClass].filter(Boolean).join(" ");
  return `<img src="${escapeHtml(getAvatarUrl(source))}" alt="头像" class="${className}" onerror="handleAvatarError(this)">`;
}

function validateAvatarFile(file) {
  if (!file) {
    throw new Error("请选择头像文件");
  }

  const extension = (file.name.split(".").pop() || "").toLowerCase();
  if (!AVATAR_EXTENSIONS.includes(extension)) {
    throw new Error("头像只支持 jpg、jpeg、png、webp 格式");
  }

  if (file.size > AVATAR_MAX_SIZE) {
    throw new Error("头像文件不能超过 2MB");
  }

  if (!["image/jpeg", "image/png", "image/webp"].includes(file.type)) {
    throw new Error("头像文件类型不合法");
  }

  return true;
}

function previewAvatar(file, imgElement) {
  validateAvatarFile(file);
  if (!imgElement) {
    return;
  }

  if (imgElement.dataset.previewUrl) {
    URL.revokeObjectURL(imgElement.dataset.previewUrl);
  }

  const previewUrl = URL.createObjectURL(file);
  imgElement.src = previewUrl;
  imgElement.dataset.previewUrl = previewUrl;
}

async function uploadAvatar(file) {
  validateAvatarFile(file);
  const formData = new FormData();
  formData.append("avatar", file);
  return request("/profile/avatar", {
    method: "POST",
    body: formData,
  });
}

function applyAvatarToPage(url) {
  const avatarUrl = getAvatarUrl(url);
  $all(".js-current-avatar").forEach(img => {
    img.src = avatarUrl;
  });
  if (window.currentUser) {
    window.currentUser.avatar_url = avatarUrl;
  }
}

function getCurrentUser() {
  return request("/auth/me");
}

async function logout() {
  if (!confirm("确定要退出登录吗？")) {
    return;
  }
  await request("/auth/logout", { method: "POST" });
  location.href = "login.html";
}

function setTheme(role) {
  const themeLink = $("#page-theme");
  if (!themeLink) {
    return;
  }
  themeLink.href = role === "student" ? "css/student-theme.css" : "css/admin.css";
}

function getRoleText(role) {
  return role === "admin" ? "管理员" : "学生";
}

function statusText(status) {
  const textMap = {
    active: "启用",
    disabled: "禁用",
    claimed: "未提交",
    submitted: "审核中",
    approved: "已完成",
    rejected: "已驳回",
    cancelled: "已取消",
    created: "待处理",
    joined: "已报名",
    easy: "简单",
    normal: "普通",
    hard: "困难",
  };
  return textMap[status] || status || "-";
}

function renderStatusBadge(status) {
  return `<span class="status-badge status-${escapeHtml(status || "default")}">${escapeHtml(statusText(status))}</span>`;
}

async function initLayout(title) {
  const user = await getCurrentUser();
  window.currentUser = user;
  setTheme(user.role);
  document.body.className = user.role === "student" ? "campus-page" : "admin-page";

  const adminMenus = [
    ["首页", "index.html"],
    ["学生管理", "users.html"],
    ["分类管理", "categories.html"],
    ["任务管理", "tasks.html"],
    ["审核管理", "review.html"],
    ["签到记录", "checkins.html"],
    ["积分流水", "points.html"],
    ["徽章管理", "badges.html"],
    ["挑战赛管理", "challenges.html"],
    ["积分商城", "rewards.html"],
    ["公告管理", "announcements.html"],
    ["排行榜", "ranking.html"],
    ["个人资料", "profile.html"],
  ];

  const studentMenus = [
    ["首页", "index.html"],
    ["我的资料", "profile.html"],
    ["任务大厅", "task_hall.html"],
    ["我的任务", "my_tasks.html"],
    ["每日签到", "checkins.html"],
    ["我的徽章", "badges.html"],
    ["挑战赛", "challenges.html"],
    ["积分商城", "rewards.html"],
    ["公告通知", "announcements.html"],
    ["排行榜", "ranking.html"],
  ];

  const menus = user.role === "admin" ? adminMenus : studentMenus;
  const currentPage = location.pathname.split("/").pop();
  const sidebarProfileClass = user.role === "admin" ? "admin-user-card" : "campus-user-card";
  const profileLinkClass = user.role === "admin" ? "admin-profile-entry" : "campus-profile-entry";

  document.body.innerHTML = `
    <div class="layout ${user.role === "admin" ? "admin-layout" : "campus-layout"}">
      <aside class="sidebar ${user.role === "admin" ? "admin-sidebar" : "campus-sidebar"}">
        <div class="brand ${user.role === "admin" ? "admin-brand" : "campus-brand"}">
          <div class="brand-title">校园任务闯关积分平台</div>
          <div class="brand-subtitle">${user.role === "admin" ? "校园任务后台管理" : "校园成长任务中心"}</div>
        </div>
        <div class="${sidebarProfileClass}">
          ${renderAvatar(user, "lg", "js-current-avatar")}
          <div>
            <strong>${escapeHtml(user.name)}</strong>
            <div class="muted">${escapeHtml(getRoleText(user.role))}</div>
            <div class="muted">${escapeHtml(user.class_name || "校园任务平台")}</div>
          </div>
        </div>
        <nav class="menu ${user.role === "admin" ? "admin-menu" : "campus-menu"}">
          ${menus.map(([label, href]) => `
            <a class="${href === currentPage ? "active" : ""}" href="${href}">${label}</a>
          `).join("")}
        </nav>
      </aside>
      <main class="main ${user.role === "admin" ? "admin-main" : "campus-main"}">
        <div class="topbar ${user.role === "admin" ? "admin-header" : "campus-header"}">
          <div>
            <h1>${escapeHtml(title)}</h1>
            <div class="muted">${escapeHtml(user.name)} · ${escapeHtml(getRoleText(user.role))} · 当前积分 ${user.points || 0}</div>
          </div>
          <div class="topbar-actions">
            <a class="${profileLinkClass}" href="profile.html">
              ${renderAvatar(user, "sm", "js-current-avatar")}
              <span>${escapeHtml(user.name)}</span>
            </a>
            <button onclick="logout()">退出登录</button>
          </div>
        </div>
        <div id="app"></div>
      </main>
    </div>
  `;

  return user;
}

function renderEmpty(selector, text = "暂无数据") {
  $(selector).innerHTML = `<div class="empty-state">${escapeHtml(text)}</div>`;
}

function renderStats(selector, stats) {
  $(selector).innerHTML = `
    <div class="grid">
      ${stats.map(item => `
        <div class="stat">
          <span class="muted">${escapeHtml(item.label)}</span>
          <strong>${escapeHtml(item.value)}</strong>
        </div>
      `).join("")}
    </div>
  `;
}

function renderTable(selector, columns, rows, actions) {
  if (!rows || rows.length === 0) {
    renderEmpty(selector);
    return;
  }

  $(selector).innerHTML = `
    <div class="table-wrap">
      <table>
        <thead>
          <tr>
            ${columns.map(column => `<th>${escapeHtml(column.title)}</th>`).join("")}
            ${actions ? "<th>操作</th>" : ""}
          </tr>
        </thead>
        <tbody>
          ${rows.map(row => `
            <tr>
              ${columns.map(column => {
                const value = typeof column.value === "function" ? column.value(row) : row[column.value];
                return `<td>${value ?? ""}</td>`;
              }).join("")}
              ${actions ? `<td>${actions(row) || ""}</td>` : ""}
            </tr>
          `).join("")}
        </tbody>
      </table>
    </div>
  `;
}

function renderPagination(selector, data, stateName, handlerName) {
  const pagination = getPagination(data);
  $(selector).innerHTML = `
    <div class="pagination-bar">
      <span class="muted">第 ${pagination.page} / ${pagination.pages || 1} 页，共 ${pagination.total} 条</span>
      <button ${pagination.has_prev ? "" : "disabled"} onclick="${handlerName}(${pagination.page - 1})">上一页</button>
      <button ${pagination.has_next ? "" : "disabled"} onclick="${handlerName}(${pagination.page + 1})">下一页</button>
      <label class="muted">每页</label>
      <select onchange="${stateName}.pageSize = Number(this.value); ${stateName}.page = 1; ${handlerName}(1);">
        ${[5, 10, 20, 50].map(size => `
          <option value="${size}" ${size === pagination.page_size ? "selected" : ""}>${size}</option>
        `).join("")}
      </select>
    </div>
  `;
}

function formatDateTime(value) {
  if (!value) {
    return "-";
  }
  return String(value).replace("T", " ").slice(0, 19);
}
