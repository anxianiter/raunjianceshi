from app.routes.auth_routes import auth_bp


# 定义统一注册蓝图的函数，将所有业务模块路由挂载到 Flask 应用中
def register_blueprints(app):

    # 注册认证模块蓝图，接口统一以 /api/auth 开头
    app.register_blueprint(auth_bp, url_prefix="/api/auth")