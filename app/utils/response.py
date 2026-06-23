from flask import jsonify


def success_response(data=None, message="success", code=200):
    return jsonify({"code": code, "message": message, "data": data if data is not None else {}}), code


def error_response(message="请求失败", code=400, data=None):
    return jsonify({"code": code, "message": message, "data": data}), code
