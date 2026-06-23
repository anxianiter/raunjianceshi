# 从 Werkzeug 安全工具中导入密码校验函数和密码加密函数
from werkzeug.security import check_password_hash, generate_password_hash

# 从项目扩展模块中导入数据库对象 db
from app.extensions import db

# 从模型统一入口中导入签到模型、任务认领模型、用户模型、用户徽章模型
from app.models import Checkin, TaskClaim, User, UserBadge


# 定义用户登录认证函数，接收用户名和密码
def authenticate_user(username, password):

    # 根据用户名查询用户表中的第一条匹配记录
    user = User.query.filter_by(username=username).first()

    # 如果用户不存在
    if not user:

        # 抛出错误，提示用户名或密码错误
        raise ValueError("用户名或密码错误")

    # 判断用户账号状态是否不是 active
    if user.status != "active":

        # 如果账号被禁用，则抛出错误提示
        raise ValueError("账号已被禁用，无法登录")

    # 使用 Werkzeug 的 check_password_hash 校验明文密码和数据库中的加密密码是否匹配
    if not check_password_hash(user.password_hash, password):

        # 如果密码不匹配，则抛出错误，仍然提示用户名或密码错误
        raise ValueError("用户名或密码错误")

    # 登录验证通过，返回当前用户对象
    return user


# 定义登录后徽章检查函数，用于在用户登录时触发徽章发放逻辑
def create_login_badges(user):

    # 在函数内部导入徽章检查与发放函数，避免模块循环导入问题
    from app.services.badge_service import check_and_award_badges

    # 尝试执行徽章检查和发放逻辑
    try:

        # 检查当前用户是否满足某些徽章条件，并自动发放徽章
        check_and_award_badges(user)

        # 提交数据库事务，保存徽章发放结果
        db.session.commit()

    # 捕获所有异常，避免徽章发放失败影响用户登录流程
    except Exception:

        # 如果发生异常，则回滚数据库事务
        db.session.rollback()


# 定义获取用户个人资料函数，根据用户 ID 查询用户信息
def get_user_profile(user_id):

    # 根据用户 ID 查询用户，如果不存在则自动返回 404 错误
    user = User.query.get_or_404(user_id)

    # 将用户对象转换为字典格式
    data = user.to_dict()

    # 查询当前用户已审核通过的任务数量，并加入返回数据
    data["completed_task_count"] = TaskClaim.query.filter_by(user_id=user.id, status="approved").count()

    # 查询当前用户的签到次数，并加入返回数据
    data["checkin_count"] = Checkin.query.filter_by(user_id=user.id).count()

    # 查询当前用户获得的徽章数量，并加入返回数据
    data["badge_count"] = UserBadge.query.filter_by(user_id=user.id).count()

    # 返回整理后的用户个人资料数据
    return data
