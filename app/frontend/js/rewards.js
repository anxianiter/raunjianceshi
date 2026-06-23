const rewardState = {
  page: 1,
  pageSize: 8,
};

const rewardOrderState = {
  page: 1,
  pageSize: 8,
};

async function loadRewards(page = rewardState.page) {
  rewardState.page = page;
  const user = await getCurrentUser();
  const query = buildQuery({
    page: rewardState.page,
    page_size: rewardState.pageSize,
    keyword: getQuery("#keyword"),
    status: getQuery("#status"),
  });
  const data = await request(`/rewards?${query}`);
  const items = getPageItems(data);

  if (user.role === "student") {
    $("#rewardList").innerHTML = items.length
      ? items.map(row => `
        <article class="shop-card">
          <h3 class="card-title">${escapeHtml(row.name)}</h3>
          <p class="muted">${escapeHtml(row.description || "")}</p>
          <div class="card-meta">
            <span class="pill">${row.cost_points} 积分</span>
            <span class="pill">库存 ${row.stock}</span>
          </div>
          <button class="glow-button" onclick="exchangeReward(${row.id})" ${row.stock <= 0 || user.points < row.cost_points ? "disabled" : ""}>
            ${row.stock <= 0 ? "库存不足" : (user.points < row.cost_points ? "积分不足" : "立即兑换")}
          </button>
        </article>
      `).join("")
      : `<div class="empty-state">积分商城暂时没有可兑换商品。</div>`;
  } else {
    renderTable("#rewardTable", [
      { title: "商品名称", value: "name" },
      { title: "说明", value: row => row.description || "-" },
      { title: "所需积分", value: "cost_points" },
      { title: "库存", value: "stock" },
      { title: "状态", value: row => renderStatusBadge(row.status) },
    ], items, row => `
      <button onclick="toggleReward(${row.id}, '${row.status === "active" ? "disabled" : "active"}')">${row.status === "active" ? "禁用" : "启用"}</button>
    `);
  }

  renderPagination("#rewardPagination", data, "rewardState", "loadRewards");
}

async function loadMyOrders() {
  const data = await request("/rewards/orders/my");
  renderTable("#myOrders", [
    { title: "商品名称", value: "reward_name" },
    { title: "消耗积分", value: "cost_points" },
    { title: "状态", value: row => renderStatusBadge(row.status) },
    { title: "时间", value: row => formatDateTime(row.created_at) },
  ], data);
}

async function loadOrders(page = rewardOrderState.page) {
  rewardOrderState.page = page;
  const query = buildQuery({
    page: rewardOrderState.page,
    page_size: rewardOrderState.pageSize,
    keyword: getQuery("#orderKeyword"),
    status: getQuery("#orderStatus"),
  });
  const data = await request(`/rewards/orders/all?${query}`);
  renderTable("#orderTable", [
    { title: "学生", value: "user_name" },
    { title: "商品", value: "reward_name" },
    { title: "消耗积分", value: "cost_points" },
    { title: "状态", value: row => renderStatusBadge(row.status) },
    { title: "创建时间", value: row => formatDateTime(row.created_at) },
  ], getPageItems(data), row => row.status === "created" ? `
    <button class="success" onclick="approveOrder(${row.id})">审核通过</button>
    <button class="danger" onclick="rejectOrder(${row.id})">驳回</button>
  ` : "");
  renderPagination("#orderPagination", data, "rewardOrderState", "loadOrders");
}

async function addReward() {
  const name = prompt("请输入商品名称");
  if (!name) return;
  const description = prompt("请输入商品说明", "");
  const costPoints = prompt("请输入所需积分", "20");
  const stock = prompt("请输入库存", "10");
  await request("/rewards", {
    method: "POST",
    body: { name, description, cost_points: costPoints, stock },
  });
  loadRewards(1);
}

async function toggleReward(id, status) {
  await request(`/rewards/${id}/status`, { method: "PATCH", body: { status } });
  loadRewards(rewardState.page);
}

async function exchangeReward(id) {
  await request(`/rewards/${id}/exchange`, { method: "POST" });
  alert("兑换成功，积分已扣减，等待管理员处理。");
  loadRewards(rewardState.page);
  loadMyOrders();
}

async function approveOrder(id) {
  await request(`/rewards/orders/${id}/approve`, { method: "POST" });
  loadOrders(rewardOrderState.page);
}

async function rejectOrder(id) {
  await request(`/rewards/orders/${id}/reject`, { method: "POST" });
  loadOrders(rewardOrderState.page);
}

(async function initRewardPage() {
  const user = await initLayout("积分商城");
  if (user.role === "student") {
    $("#app").innerHTML = `
      <section class="panel campus-hero">
        <div class="page-hero">
          <div>
            <h2>校园积分兑换区</h2>
            <p class="muted">使用日常学习获得的积分，兑换属于你的校园奖励。</p>
          </div>
        </div>
        <div id="rewardList" class="card-grid"></div>
        <div id="rewardPagination"></div>
      </section>
      <section class="panel">
        <h2>我的兑换记录</h2>
        <div id="myOrders"></div>
      </section>
    `;
    loadRewards();
    loadMyOrders();
    return;
  }

  $("#app").innerHTML = `
    <section class="panel">
      <div class="toolbar">
        <input id="keyword" placeholder="商品关键词">
        <select id="status">
          <option value="">全部状态</option>
          <option value="active">active</option>
          <option value="disabled">disabled</option>
        </select>
        <button onclick="loadRewards(1)">查询</button>
        <button onclick="$('#keyword').value=''; $('#status').value=''; loadRewards(1)">重置</button>
        <button class="success" onclick="addReward()">新增商品</button>
      </div>
      <div id="rewardTable"></div>
      <div id="rewardPagination"></div>
    </section>
    <section class="panel">
      <h2>兑换订单</h2>
      <div class="toolbar">
        <input id="orderKeyword" placeholder="学生关键词">
        <select id="orderStatus">
          <option value="">全部状态</option>
          <option value="created">created</option>
          <option value="approved">approved</option>
          <option value="rejected">rejected</option>
        </select>
        <button onclick="loadOrders(1)">查询订单</button>
      </div>
      <div id="orderTable"></div>
      <div id="orderPagination"></div>
    </section>
  `;
  loadRewards();
  loadOrders();
})();
