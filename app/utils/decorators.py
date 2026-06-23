from functools import wraps

from flask import g, session

from app.models import User
from app.utils.response import error_response


def _load_current_user():
    user_id = session.get("user_id")
    if not user_id:
        return None

    user = User.query.get(user_id)
    if not user or user.status != "active":
        session.clear()
        return None
    g.current_user = user
    return user


def login_required(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        user = _load_current_user()
        if not user:
            return error_response("请先登录", 401)
        return func(*args, **kwargs)

    return wrapper


def admin_required(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        user = _load_current_user()
        if not user:
            return error_response("请先登录", 401)
        if user.role != "admin":
            return error_response("没有操作权限", 403)
        return func(*args, **kwargs)

    return wrapper


def student_required(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        user = _load_current_user()
        if not user:
            return error_response("请先登录", 401)
        if user.role != "student":
            return error_response("没有操作权限", 403)
        return func(*args, **kwargs)

    return wrapper
