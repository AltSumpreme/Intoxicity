from datetime import datetime

from pydantic import BaseModel, Field


class AnalyzeRequest(BaseModel):
    content: str = Field(..., min_length=20, description="Journal entry text")


class SentenceEvidence(BaseModel):
    behavior: str
    severity: float
    sentence: str
    emotion_scores: dict[str, float]
    sentiment_label: str


class SentimentOutput(BaseModel):
    label: str


class AnalyzeResponse(BaseModel):
    toxicity_score: float
    risk_level: str
    sentiment: SentimentOutput
    emotional_profile: dict[str, float]
    top_behaviors: list[SentenceEvidence]


class HistoryItem(AnalyzeResponse):
    id: int
    content: str
    created_at: datetime

    class Config:
        from_attributes = True
