# 从项目扩展模块中导入数据库对象 db，用于执行数据库新增、修改等操作
from app.extensions import db

# 从模型统一入口中导入徽章、签到、任务分类、任务认领、用户、用户徽章等模型
from app.models import Badge, Checkin, TaskCategory, TaskClaim, User, UserBadge

# 从积分服务模块中导入创建积分流水的函数
from app.services.point_service import create_point_log


# 定义检查并发放徽章的函数，通常在登录、签到、任务完成等关键业务后调用
def check_and_award_badges(user):

    # 函数说明：每次关键业务完成后调用，自动检查用户是否满足某些徽章条件
    """每次关键业务完成后调用，自动检查用户是否满足某些徽章条件。"""

    # 查询所有启用状态的徽章，并按照徽章 ID 升序排列
    badges = Badge.query.filter_by(status="active").order_by(Badge.id.asc()).all()

    # 查询当前用户已经获得过的徽章 ID，并保存为集合，方便快速判断是否重复发放
    awarded_badge_ids = {
        # 从用户徽章记录中取出 badge_id
        item.badge_id for item in UserBadge.query.filter_by(user_id=user.id).all()
    }

    # 遍历所有启用状态的徽章
    for badge in badges:

        # 如果当前徽章用户已经获得过，则跳过，避免重复发放
        if badge.id in awarded_badge_ids:

            # 跳过当前循环，继续检查下一个徽章
            continue

        # 判断当前用户是否满足该徽章的发放条件
        if _is_badge_condition_met(user, badge):

            # 如果满足条件，则给用户发放该徽章
            _award_badge(user, badge)


# 定义发放徽章的内部函数
def _award_badge(user, badge):

    # 创建用户徽章记录，表示该用户获得了该徽章
    record = UserBadge(user_id=user.id, badge_id=badge.id)

    # 将用户徽章记录添加到数据库会话中，等待后续统一提交
    db.session.add(record)

    # 判断该徽章是否配置了奖励积分
    if badge.reward_points > 0:

        # 给用户增加徽章对应的奖励积分
        user.points += badge.reward_points

        # 创建一条积分流水记录，记录用户因获得徽章而增加积分
        create_point_log(

            # 当前用户 ID
            user.id,

            # 当前徽章 ID，作为关联业务 ID
            badge.id,

            # 积分来源类型为 badge，表示来源于徽章奖励
            "badge",

            # 积分变化值，即徽章奖励积分
            badge.reward_points,

            # 积分变化原因说明
            f"获得徽章：{badge.name}",

        )


# 定义判断用户是否满足徽章条件的内部函数
def _is_badge_condition_met(user, badge):

    # 获取徽章条件类型，例如 first_login、checkin_total、points_total 等
    condition_type = badge.condition_type

    # 获取徽章条件值，例如签到次数、任务数量、积分数量等
    condition_value = badge.condition_value

    # 判断条件类型是否为首次登录
    if condition_type == "first_login":

        # 首次登录类徽章只要触发检查即可满足条件
        return True

    # 判断条件类型是否为累计签到次数
    if condition_type == "checkin_total":

        # 查询当前用户的签到总次数
        total = Checkin.query.filter_by(user_id=user.id).count()

        # 判断签到总次数是否达到徽章要求
        return total >= int(condition_value)

    # 判断条件类型是否为连续签到天数
    if condition_type == "continuous_checkin_days":

        # 判断用户当前连续签到天数是否达到徽章要求
        return user.continuous_checkin_days >= int(condition_value)

    # 判断条件类型是否为审核通过的任务总数
    if condition_type == "task_approved_total":

        # 查询当前用户审核通过的任务数量
        total = (
            # 根据用户 ID 和 approved 状态筛选任务认领记录
            TaskClaim.query.filter_by(user_id=user.id, status="approved").count()
        )

        # 判断审核通过的任务数量是否达到徽章要求
        return total >= int(condition_value)

    # 判断条件类型是否为累计积分数量
    if condition_type == "points_total":

        # 判断用户当前积分是否达到徽章要求
        return user.points >= int(condition_value)

    # 判断条件类型是否为指定任务分类下完成任务数量
    if condition_type == "task_category_total":

        # 尝试解析条件值，格式一般为：分类名称|需要完成数量
        try:

            # 将条件值按照 | 分割成分类名称和数量文本
            category_name, count_text = condition_value.split("|")

            # 将需要完成的数量转换为整数
            need_count = int(count_text)

        # 如果条件值格式错误
        except ValueError:

            # 返回 False，表示不满足条件
            return False

        # 根据分类名称查询任务分类
        category = TaskCategory.query.filter_by(name=category_name).first()

        # 如果分类不存在
        if not category:

            # 返回 False，表示不满足条件
            return False

        # 查询当前用户在指定分类下审核通过的任务数量
        total = (

            # 从任务认领表开始查询，并关联任务表
            TaskClaim.query.join(TaskClaim.task)

            # 添加筛选条件
            .filter(

                # 只查询当前用户的任务认领记录
                TaskClaim.user_id == user.id,

                # 只统计审核通过的任务
                TaskClaim.status == "approved",

                # 限制任务所属分类必须等于当前分类 ID
                TaskClaim.task.has(category_id=category.id),

            )

            # 统计符合条件的记录数量
            .count()
        )

        # 判断完成数量是否达到徽章要求
        return total >= need_count

    # 判断条件类型是否为积分排行榜前 N 名
    if condition_type == "ranking_top":

        # 将条件值转换为整数，表示需要进入前 N 名
        top_n = int(condition_value)

        # 查询积分高于当前用户的活跃学生数量
        higher_count = (

            # 从用户表中查询
            User.query.filter(

                # 只统计学生用户
                User.role == "student",

                # 只统计启用状态的用户
                User.status == "active",

                # 只统计积分高于当前用户的用户
                User.points > user.points,

            )

            # 统计数量
            .count()
        )

        # 当前用户排名 = 积分高于他的用户数量 + 1
        rank = higher_count + 1

        # 判断当前用户排名是否进入前 N 名
        return rank <= top_n

    # 如果条件类型不属于以上任何一种，则默认不满足条件
    return False
