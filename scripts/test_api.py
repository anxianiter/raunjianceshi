import requests
import json

# API 基础 URL
BASE_URL = "http://127.0.0.1:5000/api/auth"

def test_api_structure():
    """测试 API 功能结构"""
    
    print("=" * 60)
    print("API 功能结构测试")
    print("=" * 60)
    
    # 测试 1: 检查服务器是否运行
    print("\n[测试 1] 检查服务器状态...")
    try:
        response = requests.get("http://127.0.0.1:5000/", timeout=3)
        print(f"✓ 服务器正在运行 (状态码: {response.status_code})")
    except Exception as e:
        print(f"✗ 服务器连接失败: {e}")
        return
    
    # 测试 2: 测试登录接口（应该返回参数缺失错误）
    print("\n[测试 2] 测试登录接口 - 缺少参数...")
    try:
        response = requests.post(f"{BASE_URL}/login", json={})
        print(f"状态码: {response.status_code}")
        print(f"响应: {json.dumps(response.json(), ensure_ascii=False, indent=2)}")
    except Exception as e:
        print(f"✗ 请求失败: {e}")
    
    # 测试 3: 测试登录接口（使用错误的凭据）
    print("\n[测试 3] 测试登录接口 - 错误凭据...")
    try:
        response = requests.post(f"{BASE_URL}/login", json={
            "username": "test",
            "password": "wrong"
        })
        print(f"状态码: {response.status_code}")
        print(f"响应: {json.dumps(response.json(), ensure_ascii=False, indent=2)}")
    except Exception as e:
        print(f"✗ 请求失败: {e}")
    
    # 测试 4: 测试 /me 接口（未登录状态）
    print("\n[测试 4] 测试获取用户信息接口 - 未登录...")
    try:
        response = requests.get(f"{BASE_URL}/me")
        print(f"状态码: {response.status_code}")
        print(f"响应: {json.dumps(response.json(), ensure_ascii=False, indent=2)}")
    except Exception as e:
        print(f"✗ 请求失败: {e}")
    
    print("\n" + "=" * 60)
    print("API 结构测试完成！")
    print("=" * 60)
    print("\n提示：要完整测试功能，需要：")
    print("1. 确保数据库已导入 SQL 脚本")
    print("2. 使用数据库中存在的用户名和密码进行登录测试")
    print("3. 查看数据库中的用户表，获取有效的测试账号")

if __name__ == "__main__":
    test_api_structure()
