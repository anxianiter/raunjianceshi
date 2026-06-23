const announcementState = {
  page: 1,
  pageSize: 8,
};

async function loadAnnouncements(page = announcementState.page) {
  announcementState.page = page;
  const user = await getCurrentUser();
  const query = buildQuery({
    page: announcementState.page,
    page_size: announcementState.pageSize,
    keyword: getQuery("#keyword"),
    status: getQuery("#status"),
  });
  const data = await request(`/announcements?${query}`);
  const items = getPageItems(data);

  if (user.role === "student") {
    $("#announcementList").innerHTML = items.length
      ? items.map(row => `
        <article class="announcement-card" onclick="showAnnouncement(${row.id})" style="cursor:pointer;">
          <h3 class="card-title">${escapeHtml(row.title)}</h3>
          <p class="muted">${formatDateTime(row.created_at)}</p>
          <p class="muted">${escapeHtml((row.content || "").slice(0, 60))}${row.content && row.content.length > 60 ? "..." : ""}</p>
        </article>
      `).join("")
      : `<div class="empty-state">今天还没有新的校园通知。</div>`;
  } else {
    renderTable("#announcementTable", [
      { title: "公告标题", value: "title" },
      { title: "状态", value: row => renderStatusBadge(row.status) },
      { title: "发布时间", value: row => formatDateTime(row.created_at) },
    ], items, row => `
      <button onclick="showAnnouncement(${row.id})">查看详情</button>
      <button onclick="toggleAnnouncement(${row.id}, '${row.status === "active" ? "disabled" : "active"}')">${row.status === "active" ? "下架" : "发布"}</button>
    `);
  }

  renderPagination("#pagination", data, "announcementState", "loadAnnouncements");
}

async function showAnnouncement(id) {
  const data = await request(`/announcements/${id}`);
  const user = await getCurrentUser();
  if (user.role === "student") {
    $("#announcementDetail").innerHTML = `
      <h3 class="card-title">${escapeHtml(data.title)}</h3>
      <p class="muted">${formatDateTime(data.created_at)}</p>
      <p>${escapeHtml(data.content || "")}</p>
    `;
    return;
  }
  alert(`${data.title}\n\n${data.content}`);
}

async function addAnnouncement() {
  const title = prompt("请输入公告标题");
  if (!title) return;
  const content = prompt("请输入公告内容", "");
  await request("/announcements", { method: "POST", body: { title, content } });
  loadAnnouncements(1);
}

async function toggleAnnouncement(id, status) {
  await request(`/announcements/${id}/status`, { method: "PATCH", body: { status } });
  loadAnnouncements(announcementState.page);
}

(async function initAnnouncementPage() {
  const user = await initLayout("公告通知");
  if (user.role === "student") {
    $("#app").innerHTML = `
      <section class="panel campus-hero">
        <div class="page-hero">
          <div>
            <h2>校园公告栏</h2>
            <p class="muted">课程验收、任务更新、排行榜说明等通知都会在这里发布。</p>
          </div>
        </div>
        <div id="announcementList" class="card-grid"></div>
        <div id="pagination"></div>
      </section>
      <section class="panel">
        <h2>公告详情</h2>
        <div id="announcementDetail" class="announcement-card">
          <p class="muted">点击上方公告卡片即可查看详情。</p>
        </div>
      </section>
    `;
  } else {
    $("#app").innerHTML = `
      <section class="panel">
        <div class="toolbar">
          <input id="keyword" placeholder="公告标题关键词">
          <select id="status">
            <option value="">全部状态</option>
            <option value="active">active</option>
            <option value="disabled">disabled</option>
          </select>
          <button onclick="loadAnnouncements(1)">查询</button>
          <button onclick="$('#keyword').value=''; $('#status').value=''; loadAnnouncements(1)">重置</button>
          <button class="success" onclick="addAnnouncement()">发布公告</button>
        </div>
        <div id="announcementTable"></div>
        <div id="pagination"></div>
      </section>
    `;
  }
  loadAnnouncements();
})();
