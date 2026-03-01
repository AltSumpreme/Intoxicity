from sqlalchemy.ext.asyncio import AsyncSession

from app.models.journal import JournalEntry
from app.services.behavior_service import analyze_sentences
from app.services.scoring_service import compute_toxicity_score


async def analyze_and_store(content: str, db: AsyncSession) -> JournalEntry:
    top_behaviors, emotional_profile, sentiment_label = await analyze_sentences(content)
    toxicity_score, risk_level = compute_toxicity_score(top_behaviors, emotional_profile)

    journal = JournalEntry(
        content=content,
        toxicity_score=toxicity_score,
        risk_level=risk_level,
        sentiment_label=sentiment_label,
        emotional_profile=emotional_profile,
        top_behaviors=top_behaviors,
    )
    db.add(journal)
    await db.commit()
    await db.refresh(journal)
    return journal
