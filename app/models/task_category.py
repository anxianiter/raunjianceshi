from datetime import datetime

from app.extensions import db


class TaskCategory(db.Model):
    """任务分类表：一个分类下面可以挂多个任务。"""

    __tablename__ = "task_categories"
    __table_args__ = (
        db.Index("idx_task_categories_name", "name"),
        {"comment": "任务分类表"},
    )

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), nullable=False, unique=True)
    description = db.Column(db.String(255))
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.now)
    updated_at = db.Column(
        db.DateTime,
        nullable=False,
        default=datetime.now,
        onupdate=datetime.now,
    )

    tasks = db.relationship("Task", back_populates="category", lazy=True)

    def to_dict(self, task_count=0):
        return {
            "id": self.id,
            "name": self.name,
            "description": self.description,
            "task_count": task_count,
            "created_at": self.created_at.strftime("%Y-%m-%d %H:%M:%S") if self.created_at else None,
            "updated_at": self.updated_at.strftime("%Y-%m-%d %H:%M:%S") if self.updated_at else None,
        }
