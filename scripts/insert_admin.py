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

# 检查 admin 是否存在
cursor.execute("SELECT id FROM users WHERE username = 'admin'")
if cursor.fetchone():
    print('admin 用户已存在')
else:
    # 插入 admin 用户
    # 密码是 123456 的 scrypt 哈希值
    admin_password_hash = 'scrypt:32768:8:1$Xnutl1a7lIXbG2Sp$588208543b7399731d3934a591925fa9a42418ecf1946317ec028363e516f3f8736b12bcd4cb4b9f2731e368bef037fc32ede213fd633540509852eeeb0dff4b'
    
    cursor.execute("""
        INSERT INTO users (id, username, password_hash, role, student_no, name, class_name, phone, avatar_url, points, continuous_checkin_days, status, created_at, updated_at)
        VALUES (1, 'admin', %s, 'admin', NULL, '系统管理员', NULL, '13800000000', '/static/uploads/avatars/avatar_1_9485d78c16344aa48cd914f0f1e8139a.jpg', 5, 0, 'active', NOW(), NOW())
    """, (admin_password_hash,))
    
    conn.commit()
    print('✓ admin 用户已成功插入数据库')

cursor.close()
conn.close()
