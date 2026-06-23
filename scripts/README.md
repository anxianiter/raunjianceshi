# Scripts 文件夹说明

本文件夹包含项目的辅助脚本和工具，用于数据库管理、测试和临时任务。

## 📁 文件列表

### 🔧 数据库相关脚本
- **check_db.py** - 检查数据库连接、表结构和数据
- **import_db.py** - 从 SQL 文件导入数据库
- **insert_admin.py** - 手动插入管理员账户（一次性使用）
- **check_users.py** - 查询用户信息（调试用）

### 🧪 测试脚本
- **test_api.py** - API 接口功能测试
- **test_login.py** - 登录功能专项测试

##  使用方法

```bash
# 检查数据库状态
python scripts/check_db.py

# 导入/重新导入数据库
python scripts/import_db.py

# 测试 API 接口
python scripts/test_api.py

# 测试登录功能
python scripts/test_login.py
```

## ️ 注意事项

1. **这些脚本仅用于开发和调试**，生产环境不需要
2. 使用前请确保已正确配置 `.env` 文件中的数据库连接信息
3. `insert_admin.py` 为一次性使用脚本，成功插入 admin 后可删除
4. `check_users.py` 为临时调试脚本，可根据需要保留或删除
5. 所有脚本都依赖项目根目录的 `.env` 配置文件

## 🗑️ 可清理的临时脚本

以下脚本在数据库初始化完成后可考虑删除：
- `insert_admin.py` - 已插入 admin 用户后不再需要
- `check_users.py` - 调试完成后不再需要
