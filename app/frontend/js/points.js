const pointState = {
  page: 1,
  pageSize: 10,
};

async function loadPoints(page = pointState.page) {
  pointState.page = page;
  const query = buildQuery({
    page: pointState.page,
    page_size: pointState.pageSize,
    keyword: getQuery("#keyword"),
    class_name: getQuery("#className"),
    source_type: getQuery("#sourceType"),
    start_date: getQuery("#startDate"),
    end_date: getQuery("#endDate"),
  });
  const data = await request(`/points/all?${query}`);
  renderTable("#table", [
    { title: "学生", value: "user_name" },
    { title: "班级", value: "class_name" },
    { title: "来源类型", value: "source_type" },
    {
      title: "积分变化",
      value: row => `
        <span class="${row.change_points >= 0 ? "points-positive" : "points-negative"}">
          ${row.change_points > 0 ? "+" : ""}${row.change_points}
        </span>
      `,
    },
    { title: "变动原因", value: row => row.reason || "-" },
    { title: "时间", value: row => formatDateTime(row.created_at) },
  ], getPageItems(data));
  renderPagination("#pagination", data, "pointState", "loadPoints");
}

(async function initPointPage() {
  await initLayout("积分流水");
  $("#app").innerHTML = `
    <section class="panel">
      <div class="toolbar">
        <input id="keyword" placeholder="学生关键词">
        <input id="className" placeholder="班级">
        <select id="sourceType">
          <option value="">全部类型</option>
          <option value="checkin">checkin</option>
          <option value="task">task</option>
          <option value="badge">badge</option>
          <option value="challenge">challenge</option>
          <option value="exchange">exchange</option>
          <option value="manual">manual</option>
        </select>
        <input id="startDate" type="date">
        <input id="endDate" type="date">
        <button onclick="loadPoints(1)">查询</button>
        <button onclick="$('#keyword').value=''; $('#className').value=''; $('#sourceType').value=''; $('#startDate').value=''; $('#endDate').value=''; loadPoints(1)">重置</button>
      </div>
      <div id="table"></div>
      <div id="pagination"></div>
    </section>
  `;
  loadPoints();
})();
