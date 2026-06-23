const reviewState = {
  page: 1,
  pageSize: 10,
};

async function loadReviews(page = reviewState.page) {
  reviewState.page = page;
  const query = buildQuery({
    page: reviewState.page,
    page_size: reviewState.pageSize,
    keyword: getQuery("#keyword"),
    class_name: getQuery("#className"),
    status: getQuery("#status"),
    start_date: getQuery("#startDate"),
    end_date: getQuery("#endDate"),
  });
  const data = await request(`/reviews?${query}`);
  renderTable("#table", [
    { title: "学生", value: "user_name" },
    { title: "班级", value: "class_name" },
    { title: "任务", value: "task_title" },
    { title: "打卡说明", value: row => row.submit_text || "-" },
    { title: "提交时间", value: row => formatDateTime(row.submit_time) },
    { title: "状态", value: row => renderStatusBadge(row.status) },
  ], getPageItems(data), row => row.status === "submitted" ? `
    <button class="success" onclick="approveReview(${row.id})">审核通过</button>
    <button class="danger" onclick="rejectReview(${row.id})">驳回</button>
  ` : "");
  renderPagination("#pagination", data, "reviewState", "loadReviews");
}

async function approveReview(id) {
  if (!confirm("确定要审核通过这条任务提交吗？")) return;
  await request(`/reviews/${id}/approve`, {
    method: "POST",
    body: { review_text: "审核通过" },
  });
  loadReviews(reviewState.page);
}

async function rejectReview(id) {
  const reviewText = prompt("请输入驳回原因", "请补充更完整的完成说明");
  if (!reviewText) return;
  await request(`/reviews/${id}/reject`, {
    method: "POST",
    body: { review_text: reviewText },
  });
  loadReviews(reviewState.page);
}

(async function initReviewPage() {
  await initLayout("任务审核");
  $("#app").innerHTML = `
    <section class="panel">
      <div class="toolbar">
        <input id="keyword" placeholder="学生 / 任务关键词">
        <input id="className" placeholder="班级">
        <select id="status">
          <option value="">全部状态</option>
          <option value="submitted">submitted</option>
          <option value="approved">approved</option>
          <option value="rejected">rejected</option>
        </select>
        <input id="startDate" type="date">
        <input id="endDate" type="date">
        <button onclick="loadReviews(1)">查询</button>
        <button onclick="$('#keyword').value=''; $('#className').value=''; $('#status').value=''; $('#startDate').value=''; $('#endDate').value=''; loadReviews(1)">重置</button>
      </div>
      <div id="table"></div>
      <div id="pagination"></div>
    </section>
  `;
  loadReviews();
})();
