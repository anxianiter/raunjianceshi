from datetime import datetime

from app.extensions import db


class Checkin(db.Model):
    """签到表：用于保存每天签到积分、奖励积分和连续签到天数。"""

    __tablename__ = "checkins"
    __table_args__ = (
        db.Index("idx_checkins_user_date", "user_id", "checkin_date"),
        db.UniqueConstraint("user_id", "checkin_date", name="uk_checkins_user_date"),
        {"comment": "每日签到记录表"},
    )

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id", ondelete="RESTRICT"), nullable=False)
    checkin_date = db.Column(db.Date, nullable=False)
    base_points = db.Column(db.Integer, nullable=False, default=2)
    bonus_points = db.Column(db.Integer, nullable=False, default=0)
    continuous_days = db.Column(db.Integer, nullable=False, default=1)
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.now)

    user = db.relationship("User", back_populates="checkins", lazy=True)

    def to_dict(self):
        return {
            "id": self.id,
            "user_id": self.user_id,
            "user_name": self.user.name if self.user else "",
            "class_name": self.user.class_name if self.user else "",
            "checkin_date": self.checkin_date.strftime("%Y-%m-%d") if self.checkin_date else None,
            "base_points": self.base_points,
            "bonus_points": self.bonus_points,
            "continuous_days": self.continuous_days,
            "created_at": self.created_at.strftime("%Y-%m-%d %H:%M:%S") if self.created_at else None,
        }
