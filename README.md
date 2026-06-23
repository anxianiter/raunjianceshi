# 校园任务闯关积分平台 - 项目结构说明

##  项目目录结构

```
ax01/
├── app/                          # 核心应用代码
│   ├── __init__.py              # Flask 应用工厂和路由注册
│   ├── config.py                # 应用配置文件
│   ├── extensions.py            # 扩展初始化（数据库、CORS等）
│   │
│   ├── models/                  # 数据模型层
│   │   ├── __init__.py          # 模型统一导出
│   │   ├── user.py              # 用户模型
│   │   ├── task.py              # 任务模型
│   │   ├── task_category.py     # 任务分类模型
│   │   ├── task_claim.py        # 任务认领模型
│   │   ├── point_log.py         # 积分日志模型
│   │   ├── checkin.py           # 签到模型
│   │   ├── badge.py             # 徽章模型
│   │   ├── challenge.py         # 挑战模型
│   │   ├── reward.py            # 奖励模型
│   │   └── announcement.py      # 公告模型
│   │
│   ├── routes/                  # API 路由层
│   │   ├── __init__.py          # 蓝图注册
│   │   └── auth_routes.py       # 认证相关路由（登录、获取用户信息）
│   │
│   ├── services/                # 业务逻辑层
│   │   ├── user_service.py      # 用户服务（登录认证、用户资料）
│   │   ├── point_service.py     # 积分服务
│   │   └── badge_service.py     # 徽章服务
│   │
│   ├── utils/                   # 工具函数层
│   │   ├── decorators.py        # 装饰器（登录校验等）
│   │   ├── response.py          # 统一响应格式
│   │   ├── validators.py        # 参数校验工具
│   │   ├── pagination.py        # 分页工具
│   │   └── upload.py            # 文件上传工具
│   │
│   ── frontend/                # 前端页面
│       ├── *.html               # HTML 页面文件
│       ├── css/                 # 样式文件
│       │   ├── common.css       # 通用样式
│       │   ├── student-theme.css # 学生主题样式
│       │   ├── admin.css        # 管理员样式
│       │   └── style.css        # 其他样式
│       └── js/                  # JavaScript 文件
│           ├── api.js           # API 请求封装
│           ├── auth.js          # 认证逻辑
│           └── ...              # 各功能模块 JS
│
├── static/                      # 静态资源
│   └── uploads/                 # 上传文件存储
│       └── avatars/             # 头像图片
│
├── scripts/                     # ️ 辅助脚本和工具（非核心）
│   ├── README.md                # 脚本使用说明
│   ├── check_db.py              # 数据库检查工具
│   ├── import_db.py             # 数据库导入工具
│   ├── insert_admin.py          # 插入管理员账户（临时）
│   ├── check_users.py           # 查询用户信息（调试）
│   ├── test_api.py              # API 测试脚本
│   └── test_login.py            # 登录测试脚本
│
├── run.py                       # 应用启动入口
├── requirements.txt             # Python 依赖包
├── .env                         # 环境变量配置（不提交到 Git）
├── .env.example                 # 环境变量示例
├── campus_quest_pro_db.sql      # 数据库 SQL 脚本
└── PROJECT_STATUS.md            # 项目状态文档
```

## 🚀 快速开始

### 1. 安装依赖
```bash
pip install -r requirements.txt
```

### 2. 配置环境变量
复制 `.env.example` 为 `.env`，并修改数据库配置：
```bash
# Windows PowerShell
cp .env.example .env

# 或使用命令提示符
copy .env.example .env
```

然后编辑 `.env` 文件，修改为你的实际配置：
```env
DB_PASSWORD=your_actual_password  # ← 修改为你的 MySQL 密码
```

**重要提示：**
- `.env` 文件包含敏感信息（如数据库密码），已添加到 `.gitignore`，不会提交到 Git
- `.env.example` 是配置模板，可以安全提交
- 首次使用请根据 `.env.example` 创建自己的 `.env` 文件

### 3. 导入数据库
```bash
python scripts/import_db.py
```

### 4. 启动应用
```bash
python run.py
```

访问：http://127.0.0.1:5000/frontend/login.html

## 🔑 默认账号

- **管理员：** admin / 123456
- **学生：** stu001 / 123456

## 📝 开发规范

### 分层架构
- **Models** - 数据模型，定义数据库表结构
- **Routes** - API 路由，处理 HTTP 请求
- **Services** - 业务逻辑，实现具体功能
- **Utils** - 工具函数，提供通用功能

### 路由规范
- API 路由使用 Blueprint 组织
- 前端页面路由在 `app/__init__.py` 中注册
- 所有 API 返回统一的 JSON 格式

### 响应格式
```json
{
  "code": 200,
  "message": "成功",
  "data": {}
}
```

## 🛠️ 常用命令

```bash
# 检查数据库
python scripts/check_db.py

# 重新导入数据库
python scripts/import_db.py

# 运行测试
python scripts/test_api.py
```

## 📝 Scripts 文件夹说明

`scripts/` 文件夹包含所有非核心的辅助脚本和工具，包括：
- **数据库管理**：check_db.py、import_db.py
- **测试脚本**：test_api.py、test_login.py
- **临时工具**：insert_admin.py、check_users.py（可根据需要删除）

详细使用说明请查看 [scripts/README.md](scripts/README.md)

##  技术栈

- **后端：** Flask + SQLAlchemy + MySQL
- **前端：** 原生 HTML/CSS/JavaScript
- **数据库：** MySQL 8.0+
- **Python：** 3.10+
