from datetime import datetime

from app.extensions import db


class Badge(db.Model):
    """徽章表：管理员维护徽章规则，业务层根据条件自动发放。"""

    __tablename__ = "badges"
    __table_args__ = (
        db.Index("idx_badges_status", "status"),
        db.Index("idx_badges_condition", "condition_type"),
        {"comment": "徽章定义表"},
    )

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), nullable=False, unique=True)
    description = db.Column(db.String(255), nullable=False)
    condition_type = db.Column(db.String(50), nullable=False)
    condition_value = db.Column(db.String(100), nullable=False)
    reward_points = db.Column(db.Integer, nullable=False, default=0)
    status = db.Column(db.String(20), nullable=False, default="active")
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.now)
    updated_at = db.Column(
        db.DateTime,
        nullable=False,
        default=datetime.now,
        onupdate=datetime.now,
    )

    user_badges = db.relationship("UserBadge", back_populates="badge", lazy=True)

    def to_dict(self):
        return {
            "id": self.id,
            "name": self.name,
            "description": self.description,
            "condition_type": self.condition_type,
            "condition_value": self.condition_value,
            "reward_points": self.reward_points,
            "status": self.status,
            "created_at": self.created_at.strftime("%Y-%m-%d %H:%M:%S") if self.created_at else None,
            "updated_at": self.updated_at.strftime("%Y-%m-%d %H:%M:%S") if self.updated_at else None,
        }


class UserBadge(db.Model):
    """用户徽章表：同一个用户不能重复领取同一个徽章。"""

    __tablename__ = "user_badges"
    __table_args__ = (
        db.UniqueConstraint("user_id", "badge_id", name="uk_user_badges_user_badge"),
        db.Index("idx_user_badges_user", "user_id"),
        {"comment": "用户已获得的徽章表"},
    )

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id", ondelete="RESTRICT"), nullable=False)
    badge_id = db.Column(db.Integer, db.ForeignKey("badges.id", ondelete="RESTRICT"), nullable=False)
    awarded_at = db.Column(db.DateTime, nullable=False, default=datetime.now)

    user = db.relationship("User", back_populates="user_badges", lazy=True)
    badge = db.relationship("Badge", back_populates="user_badges", lazy=True)

    def to_dict(self):
        return {
            "id": self.id,
            "user_id": self.user_id,
            "user_name": self.user.name if self.user else "",
            "badge_id": self.badge_id,
            "badge_name": self.badge.name if self.badge else "",
            "badge_description": self.badge.description if self.badge else "",
            "reward_points": self.badge.reward_points if self.badge else 0,
            "awarded_at": self.awarded_at.strftime("%Y-%m-%d %H:%M:%S") if self.awarded_at else None,
        }
