from datetime import datetime


def get_json_data(request):
    data = request.get_json(silent=True)
    return data if isinstance(data, dict) else {}


def require_fields(data, fields):
    missing_fields = [field for field in fields if not str(data.get(field, "")).strip()]
    if missing_fields:
        raise ValueError(f"缺少必要参数: {', '.join(missing_fields)}")


def parse_int(value, default=0, minimum=None):
    try:
        number = int(value)
    except (TypeError, ValueError):
        number = default
    if minimum is not None and number < minimum:
        return minimum
    return number


def parse_date(value, field_name="date"):
    if not value:
        return None
    try:
        return datetime.strptime(value, "%Y-%m-%d").date()
    except ValueError as exc:
        raise ValueError(f"{field_name} 格式错误，应为 YYYY-MM-DD") from exc


def parse_datetime(value, field_name="datetime"):
    if not value:
        return None
    try:
        return datetime.strptime(value, "%Y-%m-%d %H:%M:%S")
    except ValueError as exc:
        raise ValueError(f"{field_name} 格式错误，应为 YYYY-MM-DD HH:MM:SS") from exc


def validate_enum(value, options, field_name):
    if value not in options:
        raise ValueError(f"{field_name} 必须是: {', '.join(options)}")


def parse_bool(value, default=False):
    if isinstance(value, bool):
        return value
    if value in ("1", 1, "true", "True", "yes", "on"):
        return True
    if value in ("0", 0, "false", "False", "no", "off"):
        return False
    return default
