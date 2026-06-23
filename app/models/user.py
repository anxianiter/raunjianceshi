from datetime import datetime

from flask import current_app

from app.config import DEFAULT_AVATAR_DATA_URI
from app.extensions import db


class User(db.Model):
    """用户表：管理员和学生都放在同一张表中，方便教学演示角色控制。"""

    __tablename__ = "users"
    __table_args__ = (
        db.Index("idx_users_role_status", "role", "status"),
        db.Index("idx_users_class_name", "class_name"),
        {"comment": "用户表，管理员和学生共用"},
    )

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50), nullable=False, unique=True)
    password_hash = db.Column(db.String(255), nullable=False)
    role = db.Column(db.String(20), nullable=False, default="student")
    student_no = db.Column(db.String(30), unique=True)
    name = db.Column(db.String(50), nullable=False)
    class_name = db.Column(db.String(50))
    phone = db.Column(db.String(20))
    avatar_url = db.Column(db.String(255))
    points = db.Column(db.Integer, nullable=False, default=0)
    continuous_checkin_days = db.Column(db.Integer, nullable=False, default=0)
    status = db.Column(db.String(20), nullable=False, default="active")
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.now)
    updated_at = db.Column(
        db.DateTime,
        nullable=False,
        default=datetime.now,
        onupdate=datetime.now,
    )

    task_claims = db.relationship("TaskClaim", back_populates="user", lazy=True)
    point_logs = db.relationship("PointLog", back_populates="user", lazy=True)
    checkins = db.relationship("Checkin", back_populates="user", lazy=True)
    user_badges = db.relationship("UserBadge", back_populates="user", lazy=True)
    challenge_records = db.relationship("ChallengeRecord", back_populates="user", lazy=True)
    reward_orders = db.relationship("RewardOrder", back_populates="user", lazy=True)

    def to_dict(self):
        try:
            default_avatar = current_app.config.get("DEFAULT_AVATAR_URL")
        except RuntimeError:
            default_avatar = DEFAULT_AVATAR_DATA_URI
        return {
            "id": self.id,
            "username": self.username,
            "role": self.role,
            "student_no": self.student_no,
            "name": self.name,
            "class_name": self.class_name,
            "phone": self.phone,
            "avatar_url": self.avatar_url or default_avatar,
            "points": self.points,
            "continuous_checkin_days": self.continuous_checkin_days,
            "status": self.status,
            "created_at": self.created_at.strftime("%Y-%m-%d %H:%M:%S") if self.created_at else None,
            "updated_at": self.updated_at.strftime("%Y-%m-%d %H:%M:%S") if self.updated_at else None,
        }
