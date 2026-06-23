import requests
import json
import sys

# API 基础 URL
BASE_URL = "http://127.0.0.1:5000/api/auth"

def test_login_and_profile():
    """测试完整登录和获取用户信息流程"""
    
    print("=" * 60)
    print("完整功能测试 - 登录与用户信息")
    print("=" * 60)
    
    # 创建会话对象，自动管理 Cookie
    session = requests.Session()
    
    # 测试登录（数据库中所有用户的密码都是 123456）
    print("\n[测试] 使用账号 stu001 登录...")
    try:
        response = session.post(f"{BASE_URL}/login", json={
            "username": "stu001",
            "password": "123456"
        })
        
        print(f"状态码: {response.status_code}")
        result = response.json()
        print(f"响应: {json.dumps(result, ensure_ascii=False, indent=2)}")
        
        if result.get("code") == 200:
            print("\n✓ 登录成功！")
            
            # 获取用户信息
            print("\n[测试] 获取当前用户信息...")
            response = session.get(f"{BASE_URL}/me")
            print(f"状态码: {response.status_code}")
            result = response.json()
            print(f"响应: {json.dumps(result, ensure_ascii=False, indent=2)}")
            
            if result.get("code") == 200:
                print("\n✓ 获取用户信息成功！")
                
                user_data = result.get("data", {})
                print(f"\n用户详情:")
                print(f"  - 用户名: {user_data.get('username')}")
                print(f"  - 姓名: {user_data.get('name')}")
                print(f"  - 学号: {user_data.get('student_number')}")
                print(f"  - 班级: {user_data.get('class_name')}")
                print(f"  - 角色: {user_data.get('role')}")
                print(f"  - 积分: {user_data.get('points')}")
                print(f"  - 连续签到天数: {user_data.get('continuous_checkin_days')}")
            
            else:
                print(f"\n✗ 获取用户信息失败: {result.get('message')}")
        else:
            print(f"\n✗ 登录失败: {result.get('message')}")
            
    except Exception as e:
        print(f"✗ 请求失败: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
    
    print("\n" + "=" * 60)
    print("测试完成！")
    print("=" * 60)
    print("\n提示：")
    print("- 数据库中所有测试账号的密码都是: 123456")
    print("- 可用测试账号: stu001 ~ stu020")
    print("- 管理员账号: admin (如果存在)")

if __name__ == "__main__":
    test_login_and_profile()
