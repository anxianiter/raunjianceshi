import pymysql

conn = pymysql.connect(
    host='127.0.0.1', 
    port=3306, 
    user='root', 
    password='tan2179432748', 
    charset='utf8mb4'
)

cursor = conn.cursor()
cursor.execute('USE campus_quest_pro_db')

# 查询 admin 和 stu001 用户
cursor.execute('''
    SELECT id, username, name, role, status, password_hash 
    FROM users 
    WHERE username IN ('admin', 'stu001')
''')

rows = cursor.fetchall()
print('管理员和学生账户:')
for r in rows:
    print(f'ID: {r[0]}')
    print(f'用户名: {r[1]}')
    print(f'姓名: {r[2]}')
    print(f'角色: {r[3]}')
    print(f'状态: {r[4]}')
    print(f'密码哈希: {r[5][:50]}...')
    print('-' * 60)

cursor.close()
conn.close()
