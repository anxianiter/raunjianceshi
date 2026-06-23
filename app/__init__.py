"""
Flask 应用工厂模块
用于创建和配置 Flask 应用实例
"""
from pathlib import Path

from flask import Flask, redirect, send_from_directory

from app.config import Config
from app.extensions import cors, db
from app.routes import register_blueprints
from app.utils.response import error_response


def create_app():
    """
    Flask 应用工厂函数
    创建并初始化 Flask 应用实例
    
    Returns:
        Flask: 配置完成的 Flask 应用实例
    """
    # 创建 Flask 应用对象（禁用默认静态文件夹）
    app = Flask(__name__, static_folder=None)
    
    # 加载配置
    app.config.from_object(Config)
    
    # 初始化扩展
    db.init_app(app)
    cors.init_app(app, supports_credentials=True)
    
    # 注册路由
    register_frontend_routes(app)
    register_static_routes(app)
    register_blueprints(app)
    
    # 注册错误处理器
    register_error_handlers(app)
    
    return app


def register_frontend_routes(app):
    """
    注册前端页面路由
    
    Args:
        app: Flask 应用实例
    """
    frontend_dir = Path(app.root_path) / "frontend"
    
    @app.get("/")
    def index():
        """首页重定向到登录页"""
        return redirect("/frontend/login.html")
    
    @app.get("/frontend/")
    def frontend_home():
        """前端首页"""
        return send_from_directory(frontend_dir, "login.html")
    
    @app.get("/frontend/<path:filename>")
    def frontend_files(filename):
        """前端静态文件"""
        return send_from_directory(frontend_dir, filename)


def register_static_routes(app):
    """
    注册静态资源路由
    
    Args:
        app: Flask 应用实例
    """
    static_dir = Path(app.root_path).parent / "static"
    
    @app.get("/static/<path:filename>")
    def static_files(filename):
        """提供静态文件访问"""
        return send_from_directory(static_dir, filename)


def register_error_handlers(app):
    """
    注册全局错误处理器
    
    Args:
        app: Flask 应用实例
    """
    @app.errorhandler(ValueError)
    def handle_value_error(error):
        """处理参数校验错误"""
        return error_response(str(error), 400)
    
    @app.errorhandler(404)
    def handle_404(error):
        """处理 404 错误"""
        return error_response("资源不存在", 404)
    
    @app.errorhandler(500)
    def handle_500(error):
        """处理 500 错误"""
        return error_response("服务器内部错误", 500)

