const categoryState = {
  page: 1,
  pageSize: 10,
};

async function loadCategories(page = categoryState.page) {
  categoryState.page = page;
  const query = buildQuery({
    page: categoryState.page,
    page_size: categoryState.pageSize,
    keyword: getQuery("#keyword"),
  });
  const data = await request(`/categories?${query}`);
  renderTable("#table", [
    { title: "分类名称", value: "name" },
    { title: "分类说明", value: row => row.description || "-" },
    { title: "任务数量", value: "task_count" },
  ], getPageItems(data), row => `
    <button onclick="editCategory(${row.id})">编辑</button>
    <button class="danger" onclick="deleteCategory(${row.id})">删除</button>
  `);
  renderPagination("#pagination", data, "categoryState", "loadCategories");
}

async function addCategory() {
  const name = prompt("请输入分类名称");
  if (!name) return;
  const description = prompt("请输入分类说明", "");
  await request("/categories", { method: "POST", body: { name, description } });
  loadCategories(1);
}

async function editCategory(id) {
  const name = prompt("请输入新的分类名称");
  if (!name) return;
  const description = prompt("请输入新的分类说明", "");
  await request(`/categories/${id}`, { method: "PUT", body: { name, description } });
  loadCategories(categoryState.page);
}

async function deleteCategory(id) {
  if (!confirm("确定要删除这个分类吗？")) return;
  await request(`/categories/${id}`, { method: "DELETE" });
  loadCategories(categoryState.page);
}

(async function initCategoryPage() {
  await initLayout("分类管理");
  $("#app").innerHTML = `
    <section class="panel">
      <div class="toolbar">
        <input id="keyword" placeholder="分类名称关键词">
        <button onclick="loadCategories(1)">查询</button>
        <button onclick="$('#keyword').value=''; loadCategories(1)">重置</button>
        <button class="success" onclick="addCategory()">新增分类</button>
      </div>
      <div id="table"></div>
      <div id="pagination"></div>
    </section>
  `;
  loadCategories();
})();
