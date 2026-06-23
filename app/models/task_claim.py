from datetime import datetime

from app.extensions import db


class TaskClaim(db.Model):
    """任务领取记录表：保存领取、提交、审核这些状态变化。"""

    __tablename__ = "task_claims"
    __table_args__ = (
        db.Index("idx_claims_user_status", "user_id", "status"),
        db.Index("idx_claims_task_date", "task_id", "claim_date"),
        db.UniqueConstraint("user_id", "task_id", "claim_date", name="uk_claim_user_task_date"),
        {"comment": "任务领取和打卡记录表"},
    )

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id", ondelete="RESTRICT"), nullable=False)
    task_id = db.Column(db.Integer, db.ForeignKey("tasks.id", ondelete="RESTRICT"), nullable=False)
    claim_date = db.Column(db.Date, nullable=False)
    submit_text = db.Column(db.Text)
    submit_time = db.Column(db.DateTime)
    review_text = db.Column(db.String(255))
    review_time = db.Column(db.DateTime)
    status = db.Column(db.String(20), nullable=False, default="claimed")
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.now)
    updated_at = db.Column(
        db.DateTime,
        nullable=False,
        default=datetime.now,
        onupdate=datetime.now,
    )

    user = db.relationship("User", back_populates="task_claims", lazy=True)
    task = db.relationship("Task", back_populates="claims", lazy=True)

    def to_dict(self):
        return {
            "id": self.id,
            "user_id": self.user_id,
            "user_name": self.user.name if self.user else "",
            "class_name": self.user.class_name if self.user else "",
            "task_id": self.task_id,
            "task_title": self.task.title if self.task else "",
            "task_points": self.task.points if self.task else 0,
            "task_category_name": self.task.category.name if self.task and self.task.category else "",
            "task_difficulty": self.task.difficulty if self.task else "",
            "task_need_review": bool(self.task.need_review) if self.task else False,
            "task_is_blind_box": bool(self.task.is_blind_box) if self.task else False,
            "claim_date": self.claim_date.strftime("%Y-%m-%d") if self.claim_date else None,
            "submit_text": self.submit_text,
            "submit_time": self.submit_time.strftime("%Y-%m-%d %H:%M:%S") if self.submit_time else None,
            "review_text": self.review_text,
            "review_time": self.review_time.strftime("%Y-%m-%d %H:%M:%S") if self.review_time else None,
            "status": self.status,
            "created_at": self.created_at.strftime("%Y-%m-%d %H:%M:%S") if self.created_at else None,
            "updated_at": self.updated_at.strftime("%Y-%m-%d %H:%M:%S") if self.updated_at else None,
        }
