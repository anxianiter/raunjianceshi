from pathlib import Path
from uuid import uuid4

from flask import current_app
from werkzeug.utils import secure_filename


def allowed_file(filename):
    if not filename or "." not in filename:
        return False
    extension = filename.rsplit(".", 1)[1].lower()
    return extension in current_app.config["ALLOWED_AVATAR_EXTENSIONS"]


def get_avatar_url(user):
    return (getattr(user, "avatar_url", None) or current_app.config["DEFAULT_AVATAR_URL"])


def save_avatar_file(file_storage, user_id):
    if not file_storage:
        raise ValueError("请选择要上传的头像文件")
    if not file_storage.filename:
        raise ValueError("头像文件不能为空")

    original_name = secure_filename(file_storage.filename)
    if not original_name:
        raise ValueError("头像文件名不合法")
    if not allowed_file(original_name):
        raise ValueError("头像只支持 jpg、jpeg、png、webp 格式")
    if file_storage.mimetype not in {"image/jpeg", "image/png", "image/webp"}:
        raise ValueError("头像文件类型不合法")

    extension = original_name.rsplit(".", 1)[1].lower()
    file_name = f"avatar_{user_id}_{uuid4().hex}.{extension}"

    upload_dir = Path(current_app.config["AVATAR_UPLOAD_DIR"])
    try:
        upload_dir.mkdir(parents=True, exist_ok=True)
    except OSError as error:
        raise ValueError("头像上传目录不可用，请检查目录权限") from error

    save_path = upload_dir / file_name
    try:
        file_storage.save(save_path)
    except OSError as error:
        raise ValueError("头像文件保存失败，请稍后重试") from error
    return f"/static/uploads/avatars/{file_name}"


def remove_avatar_file(avatar_url):
    if not avatar_url or "/static/uploads/avatars/" not in avatar_url:
        return

    static_dir = Path(current_app.config["STATIC_DIR"])
    file_name = avatar_url.split("/static/uploads/avatars/")[-1]
    if not file_name:
        return

    file_path = static_dir / "uploads" / "avatars" / file_name
    if file_path.exists():
        file_path.unlink()
