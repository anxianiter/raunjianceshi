# 从 flask_cors 扩展库中导入 CORS 类，用于处理 Flask 项目的跨域请求问题
from flask_cors import CORS

# 从 flask_sqlalchemy 扩展库中导入 SQLAlchemy 类，用于在 Flask 项目中操作数据库
from flask_sqlalchemy import SQLAlchemy


# 创建 SQLAlchemy 数据库扩展对象 db，但此时还没有绑定具体的 Flask 应用
db = SQLAlchemy()

# 创建 CORS 跨域扩展对象 cors，但此时还没有绑定具体的 Flask 应用
cors = CORS()
