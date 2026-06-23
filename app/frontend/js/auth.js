document.body.className = "login-page";

$("#loginBtn").addEventListener("click", async () => {
  const username = $("#username").value.trim();
  const password = $("#password").value.trim();

  if (!username || !password) {
    alert("请输入用户名和密码");
    return;
  }

  const data = await request("/auth/login", {
    method: "POST",
    body: { username, password },
  });

  if (data) {
    location.href = "index.html";
  }
});

$("#password").addEventListener("keydown", event => {
  if (event.key === "Enter") {
    $("#loginBtn").click();
  }
});
