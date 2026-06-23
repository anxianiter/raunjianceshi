# 从 Flask 中导入 Blueprint、g、request、session
from flask import Blueprint, g, request, session

# 从服务层中导入用户服务模块，用于处理登录认证、用户资料查询等业务逻辑
from app.services import user_service

# 从装饰器工具中导入登录校验装饰器
from app.utils.decorators import login_required

# 从响应工具中导入统一成功响应函数
from app.utils.response import success_response

# 从参数校验工具中导入 JSON 数据获取函数和必填字段校验函数
from app.utils.validators import get_json_data, require_fields


# 创建认证模块蓝图，蓝图名称为 auth
auth_bp = Blueprint("auth", __name__)


# 定义登录接口，使用 POST 请求访问 /login
@auth_bp.post("/login")
# 定义登录处理函数
def login():

    # 获取前端提交的 JSON 请求数据
    data = get_json_data(request)

    # 校验 username 和 password 是否为必填参数
    require_fields(data, ["username", "password"])

    # 调用用户服务层的登录认证函数，校验用户名和密码是否正确
    user = user_service.authenticate_user(data["username"], data["password"])

    # 将当前登录用户 ID 保存到 session 中
    session["user_id"] = user.id

    # 将当前登录用户名保存到 session 中
    session["username"] = user.username

    # 将当前用户角色保存到 session 中
    session["role"] = user.role

    # 将当前用户姓名保存到 session 中
    session["name"] = user.name

    # 用户登录成功后，检查是否满足徽章发放条件
    user_service.create_login_badges(user)

    # 返回登录成功响应，并返回当前用户完整个人资料
    return success_response(user_service.get_user_profile(user.id), "登录成功")


# 定义获取当前登录用户信息接口，使用 GET 请求访问 /me
@auth_bp.get("/me")
# 添加登录校验，只有登录用户才能访问该接口
@login_required
# 定义获取当前用户信息的处理函数
def me():

    # 根据当前登录用户 ID 查询用户资料，并返回成功响应
    return success_response(user_service.get_user_profile(g.current_user.id))
