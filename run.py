from app import create_app

# 创建 Flask 应用实例
app = create_app()

if __name__ == '__main__':
    # 运行 Flask 应用
    # debug=True 开启调试模式，代码修改后自动重启
    # host='0.0.0.0' 允许外部访问
    # port=5000 设置端口号
    app.run(debug=True, host='0.0.0.0', port=5000)
