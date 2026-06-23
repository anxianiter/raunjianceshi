from datetime import datetime

from app.extensions import db


class Reward(db.Model):
    """积分商城商品表：保存可兑换奖励和库存。"""

    __tablename__ = "rewards"
    __table_args__ = (
        db.Index("idx_rewards_status", "status"),
        {"comment": "积分商城商品表"},
    )

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), nullable=False, unique=True)
    description = db.Column(db.String(255), nullable=False)
    cost_points = db.Column(db.Integer, nullable=False, default=20)
    stock = db.Column(db.Integer, nullable=False, default=0)
    status = db.Column(db.String(20), nullable=False, default="active")
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.now)
    updated_at = db.Column(
        db.DateTime,
        nullable=False,
        default=datetime.now,
        onupdate=datetime.now,
    )

    orders = db.relationship("RewardOrder", back_populates="reward", lazy=True)

    def to_dict(self):
        return {
            "id": self.id,
            "name": self.name,
            "description": self.description,
            "cost_points": self.cost_points,
            "stock": self.stock,
            "status": self.status,
            "created_at": self.created_at.strftime("%Y-%m-%d %H:%M:%S") if self.created_at else None,
            "updated_at": self.updated_at.strftime("%Y-%m-%d %H:%M:%S") if self.updated_at else None,
        }


class RewardOrder(db.Model):
    """兑换订单表：学生发起兑换后生成订单，管理员可审核处理。"""

    __tablename__ = "reward_orders"
    __table_args__ = (
        db.Index("idx_reward_orders_user_status", "user_id", "status"),
        {"comment": "积分兑换订单表"},
    )

    id = db.Column(db.Integer, primary_key=True)
    reward_id = db.Column(db.Integer, db.ForeignKey("rewards.id", ondelete="RESTRICT"), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id", ondelete="RESTRICT"), nullable=False)
    cost_points = db.Column(db.Integer, nullable=False)
    status = db.Column(db.String(20), nullable=False, default="created")
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.now)
    updated_at = db.Column(
        db.DateTime,
        nullable=False,
        default=datetime.now,
        onupdate=datetime.now,
    )

    reward = db.relationship("Reward", back_populates="orders", lazy=True)
    user = db.relationship("User", back_populates="reward_orders", lazy=True)

    def to_dict(self):
        return {
            "id": self.id,
            "reward_id": self.reward_id,
            "reward_name": self.reward.name if self.reward else "",
            "user_id": self.user_id,
            "user_name": self.user.name if self.user else "",
            "class_name": self.user.class_name if self.user else "",
            "cost_points": self.cost_points,
            "status": self.status,
            "created_at": self.created_at.strftime("%Y-%m-%d %H:%M:%S") if self.created_at else None,
            "updated_at": self.updated_at.strftime("%Y-%m-%d %H:%M:%S") if self.updated_at else None,
        }
