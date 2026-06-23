import pymysql
import os

# 数据库配置
DB_CONFIG = {
    'host': '127.0.0.1',
    'port': 3306,
    'user': 'root',
    'password': 'tan2179432748',
    'charset': 'utf8mb4'
}

DB_NAME = 'campus_quest_pro_db'
SQL_FILE = 'campus_quest_pro_db.sql'

def import_database():
    """创建并导入数据库"""
    print("=" * 60)
    print("数据库导入工具")
    print("=" * 60)
    
    try:
        # 检查 SQL 文件是否存在
        if not os.path.exists(SQL_FILE):
            print(f"✗ SQL 文件 '{SQL_FILE}' 不存在")
            return False
        
        print(f"\n[步骤 1] 连接到 MySQL 服务器...")
        connection = pymysql.connect(**DB_CONFIG)
        cursor = connection.cursor()
        print("✓ 连接成功")
        
        # 创建数据库（如果不存在）
        print(f"\n[步骤 2] 创建数据库 '{DB_NAME}'...")
        cursor.execute(f"CREATE DATABASE IF NOT EXISTS `{DB_NAME}` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci")
        print("✓ 数据库创建成功")
        
        # 切换到新创建的数据库
        cursor.execute(f"USE `{DB_NAME}`")
        print(f"✓ 已切换到数据库 '{DB_NAME}'")
        
        # 读取 SQL 文件
        print(f"\n[步骤 3] 读取 SQL 文件 '{SQL_FILE}'...")
        with open(SQL_FILE, 'r', encoding='utf-8') as f:
            sql_content = f.read()
        print(f"✓ SQL 文件读取成功 (文件大小: {len(sql_content)} 字节)")
        
        # 执行 SQL 语句
        print(f"\n[步骤 4] 执行 SQL 脚本...")
        
        # 分割 SQL 语句（按分号分割）
        sql_statements = sql_content.split(';')
        
        executed = 0
        skipped = 0
        
        for statement in sql_statements:
            statement = statement.strip()
            if statement and not statement.startswith('--'):
                try:
                    cursor.execute(statement)
                    executed += 1
                except Exception as e:
                    # 忽略一些常见的错误（如表已存在）
                    if 'already exists' not in str(e).lower():
                        print(f"⚠ 警告: {e}")
                    skipped += 1
        
        # 提交事务
        connection.commit()
        print(f"✓ SQL 脚本执行完成 (执行: {executed} 条, 跳过: {skipped} 条)")
        
        # 验证导入结果
        print(f"\n[步骤 5] 验证导入结果...")
        cursor.execute("SHOW TABLES")
        tables = cursor.fetchall()
        print(f"✓ 数据库中共有 {len(tables)} 个表:")
        for table in tables:
            cursor.execute(f"SELECT COUNT(*) FROM `{table[0]}`")
            count = cursor.fetchone()[0]
            print(f"  - {table[0]}: {count} 条记录")
        
        cursor.close()
        connection.close()
        
        print("\n" + "=" * 60)
        print("✓ 数据库导入成功！")
        print("=" * 60)
        return True
        
    except pymysql.err.OperationalError as e:
        print(f"\n✗ 数据库连接失败: {e}")
        print("\n请检查:")
        print("1. MySQL 服务是否已启动")
        print("2. 数据库账号密码是否正确")
        return False
    except Exception as e:
        print(f"\n✗ 导入失败: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    success = import_database()
    if success:
        print("\n现在可以运行程序了！")
        print("执行命令: python run.py")
    else:
        print("\n导入失败，请检查错误信息")
