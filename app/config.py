# 导入 os 模块，用于读取系统环境变量
import os

# 从 pathlib 模块中导入 Path 类，用于处理文件路径
from pathlib import Path

# 从 dotenv 模块中导入 load_dotenv，用于加载 .env 环境变量文件
from dotenv import load_dotenv


# 获取当前 config.py 文件所在目录的上一级目录，作为项目根目录
BASE_DIR = Path(__file__).resolve().parent.parent

# 加载项目根目录下的 .env 配置文件
load_dotenv(BASE_DIR / ".env")

# 定义默认头像的数据 URI，当前使用的是 SVG 图片的字符串形式
DEFAULT_AVATAR_DATA_URI = (

    # 声明这是一个 SVG 格式的图片数据 URI
    "data:image/svg+xml;utf8,"

    # 定义 SVG 标签，设置头像图片的宽高和视图区域
    "%3Csvg xmlns='http://www.w3.org/2000/svg' width='120' height='120' viewBox='0 0 120 120'%3E"

    # 定义头像背景矩形，宽高为 120，圆角为 60，背景颜色为浅蓝色
    "%3Crect width='120' height='120' rx='60' fill='%23EAF3FF'/%3E"

    # 定义头像中的圆形部分，表示人物头部，颜色为蓝色
    "%3Ccircle cx='60' cy='42' r='24' fill='%233B82F6'/%3E"

    # 定义头像中的路径部分，表示人物身体，颜色为浅蓝色
    "%3Cpath d='M26 95c9-15 21-23 34-23s25 8 34 23' fill='%2393C5FD'/%3E"

    # 结束 SVG 标签
    "%3C/svg%3E"
)


# 定义项目配置类，用于集中管理 Flask、数据库、上传路径等配置信息
class Config:

    # 设置 Flask 项目的安全密钥，优先从 .env 中读取，读取不到时使用默认值
    SECRET_KEY = os.getenv("SECRET_KEY", "campus-quest-pro-secret-key")

    # 设置数据库主机地址，优先从 .env 中读取，默认连接本机 127.0.0.1
    DB_HOST = os.getenv("DB_HOST", "127.0.0.1")

    # 设置数据库端口号，优先从 .env 中读取，MySQL 默认端口为 3306
    DB_PORT = os.getenv("DB_PORT", "3306")

    # 设置数据库名称，优先从 .env 中读取，默认数据库名为 campus_quest_pro_db
    DB_NAME = os.getenv("DB_NAME", "campus_quest_pro_db")

    # 设置数据库用户名，优先从 .env 中读取，默认用户名为 root
    DB_USER = os.getenv("DB_USER", "root")

    # 设置数据库密码，优先从 .env 中读取，默认密码为 root
    DB_PASSWORD = os.getenv("DB_PASSWORD", "root")

    # 配置 SQLAlchemy 数据库连接地址
    SQLALCHEMY_DATABASE_URI = (

        # 拼接 MySQL 数据库连接字符串，使用 PyMySQL 作为数据库驱动
        f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

        # 指定数据库连接字符集为 utf8mb4，支持中文和 emoji 等字符
        "?charset=utf8mb4"
    )

    # 配置是否追踪 SQLAlchemy 对象修改，通常设置为 False 以减少性能开销
    SQLALCHEMY_TRACK_MODIFICATIONS = (

        # 从环境变量读取配置，并转换为小写后判断是否等于 true
        os.getenv("SQLALCHEMY_TRACK_MODIFICATIONS", "False").lower() == "true"
    )

    # 配置 JSON 是否使用 ASCII 编码，False 表示接口返回中文时不转义为 Unicode
    JSON_AS_ASCII = os.getenv("JSON_AS_ASCII", "False").lower() == "true"

    # 配置上传文件的最大大小，默认限制为 2MB
    MAX_CONTENT_LENGTH = int(os.getenv("MAX_CONTENT_LENGTH", 2 * 1024 * 1024))

    # 配置 static 静态资源目录路径
    STATIC_DIR = BASE_DIR / "static"

    # 配置头像上传目录，头像文件会保存到 static/uploads/avatars 目录下
    AVATAR_UPLOAD_DIR = STATIC_DIR / "uploads" / "avatars"

    # 配置默认头像地址，优先从环境变量读取，读取不到时使用内置 SVG 默认头像
    DEFAULT_AVATAR_URL = os.getenv("DEFAULT_AVATAR_URL", DEFAULT_AVATAR_DATA_URI)

    # 配置允许上传的头像文件后缀类型
    ALLOWED_AVATAR_EXTENSIONS = {"jpg", "jpeg", "png", "webp"}
