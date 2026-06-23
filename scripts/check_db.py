import pymysql
import sys

# 数据库配置
DB_CONFIG = {
    'host': '127.0.0.1',
    'port': 3306,
    'user': 'root',
    'password': 'tan2179432748',
    'charset': 'utf8mb4'
}

DB_NAME = 'campus_quest_pro_db'

def check_database():
    """检查数据库状态"""
    print("=" * 60)
    print("数据库连接检查")
    print("=" * 60)
    
    try:
        # 尝试连接到 MySQL 服务器
        print("\n[步骤 1] 连接到 MySQL 服务器...")
        connection = pymysql.connect(**DB_CONFIG)
        print("✓ MySQL 服务器连接成功")
        
        cursor = connection.cursor()
        
        # 检查数据库是否存在
        print(f"\n[步骤 2] 检查数据库 '{DB_NAME}' 是否存在...")
        cursor.execute(f"SHOW DATABASES LIKE '{DB_NAME}'")
        result = cursor.fetchone()
        
        if result:
            print(f"✓ 数据库 '{DB_NAME}' 存在")
            
            # 切换到该数据库
            cursor.execute(f"USE {DB_NAME}")
            print(f"✓ 已切换到数据库 '{DB_NAME}'")
            
            # 检查表
            print(f"\n[步骤 3] 检查数据库中的表...")
            cursor.execute("SHOW TABLES")
            tables = cursor.fetchall()
            
            if tables:
                print(f"✓ 找到 {len(tables)} 个表:")
                for table in tables:
                    print(f"  - {table[0]}")
                
                # 检查用户表
                print(f"\n[步骤 4] 检查用户表数据...")
                cursor.execute("SELECT COUNT(*) FROM user")
                user_count = cursor.fetchone()[0]
                print(f"✓ 用户表中有 {user_count} 个用户")
                
                if user_count > 0:
                    print("\n示例用户:")
                    cursor.execute("SELECT id, username, name, role FROM user LIMIT 5")
                    users = cursor.fetchall()
                    for user in users:
                        print(f"  ID: {user[0]}, 用户名: {user[1]}, 姓名: {user[2]}, 角色: {user[3]}")
            else:
                print("✗ 数据库中没有表，需要导入 SQL 脚本")
                print(f"\n请执行以下命令导入数据库:")
                print(f"mysql -u root -p {DB_NAME} < campus_quest_pro_db.sql")
        else:
            print(f"✗ 数据库 '{DB_NAME}' 不存在")
            print(f"\n请先创建数据库并导入 SQL 脚本:")
            print(f"CREATE DATABASE {DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;")
            print(f"USE {DB_NAME};")
            print(f"SOURCE campus_quest_pro_db.sql;")
        
        cursor.close()
        connection.close()
        
    except pymysql.err.OperationalError as e:
        print(f"✗ 数据库连接失败: {e}")
        print("\n请检查:")
        print("1. MySQL 服务是否已启动")
        print("2. 数据库账号密码是否正确")
        print("3. 数据库主机和端口是否正确")
        sys.exit(1)
    except Exception as e:
        print(f"✗ 发生错误: {e}")
        sys.exit(1)
    
    print("\n" + "=" * 60)
    print("数据库检查完成！")
    print("=" * 60)

if __name__ == "__main__":
    check_database()
