from datetime import datetime

from app.extensions import db


class Task(db.Model):
    """任务表：保存任务标题、积分、难度、是否允许盲盒抽取等业务字段。"""

    __tablename__ = "tasks"
    __table_args__ = (
        db.Index("idx_tasks_category_status", "category_id", "status"),
        db.Index("idx_tasks_blind_box", "is_blind_box"),
        {"comment": "任务库表"},
    )

    id = db.Column(db.Integer, primary_key=True)
    category_id = db.Column(
        db.Integer,
        db.ForeignKey("task_categories.id", ondelete="RESTRICT"),
        nullable=False,
    )
    title = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    points = db.Column(db.Integer, nullable=False, default=5)
    difficulty = db.Column(db.String(20), nullable=False, default="easy")
    status = db.Column(db.String(20), nullable=False, default="active")
    is_blind_box = db.Column(db.Boolean, nullable=False, default=False)
    need_review = db.Column(db.Boolean, nullable=False, default=True)
    daily_limit = db.Column(db.Integer, nullable=False, default=20)
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.now)
    updated_at = db.Column(
        db.DateTime,
        nullable=False,
        default=datetime.now,
        onupdate=datetime.now,
    )

    category = db.relationship("TaskCategory", back_populates="tasks", lazy=True)
    claims = db.relationship("TaskClaim", back_populates="task", lazy=True)

    def to_dict(self):
        return {
            "id": self.id,
            "category_id": self.category_id,
            "category_name": self.category.name if self.category else "",
            "title": self.title,
            "description": self.description,
            "points": self.points,
            "difficulty": self.difficulty,
            "status": self.status,
            "is_blind_box": bool(self.is_blind_box),
            "need_review": bool(self.need_review),
            "daily_limit": self.daily_limit,
            "created_at": self.created_at.strftime("%Y-%m-%d %H:%M:%S") if self.created_at else None,
            "updated_at": self.updated_at.strftime("%Y-%m-%d %H:%M:%S") if self.updated_at else None,
        }
