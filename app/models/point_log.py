from datetime import datetime

from app.extensions import db


class PointLog(db.Model):
    """积分流水表：记录每一次加分和扣分，便于教学演示数据留痕。"""

    __tablename__ = "point_logs"
    __table_args__ = (
        db.Index("idx_point_logs_user_type", "user_id", "source_type"),
        db.Index("idx_point_logs_created_at", "created_at"),
        {"comment": "积分流水表"},
    )

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id", ondelete="RESTRICT"), nullable=False)
    related_id = db.Column(db.Integer)
    source_type = db.Column(db.String(20), nullable=False)
    change_points = db.Column(db.Integer, nullable=False)
    reason = db.Column(db.String(255), nullable=False)
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.now)

    user = db.relationship("User", back_populates="point_logs", lazy=True)

    def to_dict(self):
        return {
            "id": self.id,
            "user_id": self.user_id,
            "user_name": self.user.name if self.user else "",
            "class_name": self.user.class_name if self.user else "",
            "related_id": self.related_id,
            "source_type": self.source_type,
            "change_points": self.change_points,
            "reason": self.reason,
            "created_at": self.created_at.strftime("%Y-%m-%d %H:%M:%S") if self.created_at else None,
        }
