from app.utils.validators import parse_date, parse_int


def parse_pagination_args(params):
    page = parse_int(params.get("page", 1), default=1, minimum=1)
    page_size = parse_int(params.get("page_size", 10), default=10, minimum=1)
    page_size = min(page_size, 100)

    start_date = parse_date(params.get("start_date"), "start_date")
    end_date = parse_date(params.get("end_date"), "end_date")
    if start_date and end_date and start_date > end_date:
        raise ValueError("start_date 不能大于 end_date")

    return {
        "page": page,
        "page_size": page_size,
        "keyword": (params.get("keyword") or "").strip(),
        "status": (params.get("status") or "").strip(),
        "class_name": (params.get("class_name") or "").strip(),
        "category_id": (params.get("category_id") or "").strip(),
        "start_date": start_date,
        "end_date": end_date,
    }


def build_pagination_response(pagination, items):
    return {
        "items": items,
        "pagination": {
            "page": pagination.page,
            "page_size": pagination.per_page,
            "total": pagination.total,
            "pages": pagination.pages,
            "has_prev": pagination.has_prev,
            "has_next": pagination.has_next,
        },
    }
