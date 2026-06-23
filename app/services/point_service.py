# 从 datetime 模块中导入 datetime 类，用于获取当前时间
from datetime import datetime

# 从 SQLAlchemy 中导入 or_ 条件函数，用于后续构造“或”查询条件
from sqlalchemy import or_

# 从模型统一入口中导入 PointLog 积分流水模型和 User 用户模型
from app.models import PointLog, User

# 从项目扩展模块中导入数据库对象 db
from app.extensions import db

# 从分页工具模块中导入分页参数解析函数
from app.utils.pagination import parse_pagination_args


# 定义创建积分流水记录的函数
def create_point_log(user_id, related_id, source_type, change_points, reason):

    # 函数说明：这里只创建积分流水记录，不提交事务，方便其他业务统一控制提交或回滚
    """创建积分流水，但不在这里提交事务，方便被其他业务复用。"""

    # 创建 PointLog 积分流水对象
    log = PointLog(

        # 设置积分流水所属的用户 ID
        user_id=user_id,

        # 设置关联业务 ID，例如任务 ID、签到 ID、奖励订单 ID 等
        related_id=related_id,

        # 设置积分来源类型，例如 task、checkin、reward 等
        source_type=source_type,

        # 设置积分变化值，正数表示增加积分，负数表示扣减积分
        change_points=change_points,

        # 设置积分变化原因说明
        reason=reason,

        # 设置积分流水创建时间为当前时间
        created_at=datetime.now(),

    )

    # 将积分流水对象添加到数据库会话中，等待后续统一提交
    db.session.add(log)

    # 返回创建好的积分流水对象
    return log
