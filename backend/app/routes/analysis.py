from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.db.session import get_db
from app.models.journal import JournalEntry
from app.schemas.analysis import AnalyzeRequest, AnalyzeResponse, HistoryItem, SentimentOutput
from app.services.analysis_service import analyze_and_store

router = APIRouter(prefix="/api/v1", tags=["analysis"])


@router.post("/analyze", response_model=AnalyzeResponse, status_code=status.HTTP_200_OK)
async def analyze_journal(payload: AnalyzeRequest, db: AsyncSession = Depends(get_db)) -> AnalyzeResponse:
    try:
        journal = await analyze_and_store(payload.content, db)
    except Exception as exc:  # noqa: BLE001
        raise HTTPException(status_code=500, detail="Analysis failed. Please retry.") from exc

    return AnalyzeResponse(
        toxicity_score=journal.toxicity_score,
        risk_level=journal.risk_level,
        sentiment=SentimentOutput(label=journal.sentiment_label),
        emotional_profile=journal.emotional_profile,
        top_behaviors=journal.top_behaviors,
    )


@router.get("/history", response_model=list[HistoryItem])
async def get_history(db: AsyncSession = Depends(get_db)) -> list[HistoryItem]:
    result = await db.execute(select(JournalEntry).order_by(JournalEntry.created_at.desc()))
    entries = result.scalars().all()

    return [
        HistoryItem(
            id=entry.id,
            content=entry.content,
            toxicity_score=entry.toxicity_score,
            risk_level=entry.risk_level,
            sentiment=SentimentOutput(label=entry.sentiment_label),
            emotional_profile=entry.emotional_profile,
            top_behaviors=entry.top_behaviors,
            created_at=entry.created_at,
        )
        for entry in entries
    ]
