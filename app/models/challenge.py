from datetime import datetime

from app.extensions import db


class Challenge(db.Model):
    """挑战赛表：保存活动时间和奖励积分。"""

    __tablename__ = "challenges"
    __table_args__ = (
        db.Index("idx_challenges_status_time", "status", "start_time", "end_time"),
        {"comment": "挑战赛活动表"},
    )

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    reward_points = db.Column(db.Integer, nullable=False, default=10)
    start_time = db.Column(db.DateTime, nullable=False)
    end_time = db.Column(db.DateTime, nullable=False)
    status = db.Column(db.String(20), nullable=False, default="active")
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.now)
    updated_at = db.Column(
        db.DateTime,
        nullable=False,
        default=datetime.now,
        onupdate=datetime.now,
    )

    records = db.relationship("ChallengeRecord", back_populates="challenge", lazy=True)

    def to_dict(self):
        return {
            "id": self.id,
            "title": self.title,
            "description": self.description,
            "reward_points": self.reward_points,
            "start_time": self.start_time.strftime("%Y-%m-%d %H:%M:%S") if self.start_time else None,
            "end_time": self.end_time.strftime("%Y-%m-%d %H:%M:%S") if self.end_time else None,
            "status": self.status,
            "created_at": self.created_at.strftime("%Y-%m-%d %H:%M:%S") if self.created_at else None,
            "updated_at": self.updated_at.strftime("%Y-%m-%d %H:%M:%S") if self.updated_at else None,
        }


class ChallengeRecord(db.Model):
    """挑战赛参与记录表：和任务审核类似，也有提交与审核状态。"""

    __tablename__ = "challenge_records"
    __table_args__ = (
        db.UniqueConstraint("challenge_id", "user_id", name="uk_challenge_user"),
        db.Index("idx_challenge_records_status", "status"),
        {"comment": "挑战赛报名和提交记录表"},
    )

    id = db.Column(db.Integer, primary_key=True)
    challenge_id = db.Column(db.Integer, db.ForeignKey("challenges.id", ondelete="RESTRICT"), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id", ondelete="RESTRICT"), nullable=False)
    submit_text = db.Column(db.Text)
    submit_time = db.Column(db.DateTime)
    review_text = db.Column(db.String(255))
    review_time = db.Column(db.DateTime)
    status = db.Column(db.String(20), nullable=False, default="joined")
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.now)
    updated_at = db.Column(
        db.DateTime,
        nullable=False,
        default=datetime.now,
        onupdate=datetime.now,
    )

    challenge = db.relationship("Challenge", back_populates="records", lazy=True)
    user = db.relationship("User", back_populates="challenge_records", lazy=True)

    def to_dict(self):
        return {
            "id": self.id,
            "challenge_id": self.challenge_id,
            "challenge_title": self.challenge.title if self.challenge else "",
            "reward_points": self.challenge.reward_points if self.challenge else 0,
            "user_id": self.user_id,
            "user_name": self.user.name if self.user else "",
            "class_name": self.user.class_name if self.user else "",
            "submit_text": self.submit_text,
            "submit_time": self.submit_time.strftime("%Y-%m-%d %H:%M:%S") if self.submit_time else None,
            "review_text": self.review_text,
            "review_time": self.review_time.strftime("%Y-%m-%d %H:%M:%S") if self.review_time else None,
            "status": self.status,
            "created_at": self.created_at.strftime("%Y-%m-%d %H:%M:%S") if self.created_at else None,
            "updated_at": self.updated_at.strftime("%Y-%m-%d %H:%M:%S") if self.updated_at else None,
        }
