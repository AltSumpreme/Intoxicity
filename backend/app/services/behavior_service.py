from __future__ import annotations

import asyncio
from collections import defaultdict

import nltk

from app.core.model_loader import model_registry

BEHAVIOR_LABELS = [
    "gaslighting",
    "emotional manipulation",
    "controlling behavior",
    "isolation",
    "verbal degradation",
    "jealousy aggression",
    "intimidation",
    "financial control",
    "healthy communication",
]

EMOTION_LABELS = ["anger", "sadness", "fear", "joy", "disgust", "surprise"]
SENTIMENT_LABELS = ["positive sentiment", "negative sentiment"]

IMPACT_SUMMARIES = {
    "gaslighting": "Repeated denial of your lived experience can quietly erode self-trust over time.",
    "emotional manipulation": "Emotional pressure can blur boundaries and make your needs feel less valid.",
    "controlling behavior": "Control-driven dynamics can reduce your sense of autonomy and personal safety.",
    "isolation": "Isolation patterns can weaken support systems and increase emotional dependence.",
    "verbal degradation": "Belittling language can chip away at confidence and create persistent self-doubt.",
    "jealousy aggression": "Jealous aggression can create instability, tension, and emotional hypervigilance.",
    "intimidation": "Intimidation can make it harder to express yourself freely and safely.",
    "financial control": "Financial control can limit independence and make decision-making feel constrained.",
}


async def analyze_sentences(content: str) -> tuple[list[dict], dict[str, float], str, str]:
    sentences = [segment.strip() for segment in nltk.sent_tokenize(content) if segment.strip()]

    if not sentences:
        empty_profile = {label: 0.0 for label in EMOTION_LABELS}
        return (
            [],
            empty_profile,
            "Your reflection carries emotional weight and deserves gentle care.",
            "negative sentiment",
        )

    emotion_totals = {label: 0.0 for label in EMOTION_LABELS}
    sentiment_votes = defaultdict(int)
    behavior_candidates = []

    classifier = model_registry.classifier

    behavior_batch, emotion_batch, sentiment_batch = await asyncio.gather(
        asyncio.to_thread(classifier, sentences, BEHAVIOR_LABELS, multi_label=True),
        asyncio.to_thread(classifier, sentences, EMOTION_LABELS, multi_label=True),
        asyncio.to_thread(classifier, sentences, SENTIMENT_LABELS, multi_label=True),
    )

    for index, sentence in enumerate(sentences):
        behavior_scores = {
            label: float(score)
            for label, score in zip(behavior_batch[index]["labels"], behavior_batch[index]["scores"], strict=False)
        }
        emotion_scores = {
            label: float(score)
            for label, score in zip(emotion_batch[index]["labels"], emotion_batch[index]["scores"], strict=False)
        }
        sentiment_scores = {
            label: float(score)
            for label, score in zip(sentiment_batch[index]["labels"], sentiment_batch[index]["scores"], strict=False)
        }

        top_behavior = max(behavior_scores.items(), key=lambda item: item[1])
        top_sentiment = max(sentiment_scores.items(), key=lambda item: item[1])[0]

        sentiment_votes[top_sentiment] += 1

        for emotion in EMOTION_LABELS:
            emotion_totals[emotion] += emotion_scores.get(emotion, 0.0)

        if top_behavior[0] != "healthy communication" and top_behavior[1] >= 0.5:
            behavior_candidates.append(
                {
                    "category": top_behavior[0],
                    "severity": round(top_behavior[1], 4),
                    "evidence": sentence,
                    "sentiment": top_sentiment,
                    "impact_summary": IMPACT_SUMMARIES[top_behavior[0]],
                }
            )

    emotional_profile = {
        label: round(emotion_totals[label] / len(sentences), 4) for label in EMOTION_LABELS
    }

    grouped_best = {}
    for candidate in behavior_candidates:
        behavior = candidate["category"]
        if behavior not in grouped_best or candidate["severity"] > grouped_best[behavior]["severity"]:
            grouped_best[behavior] = candidate

    top_behaviors = sorted(grouped_best.values(), key=lambda item: item["severity"], reverse=True)[:5]
    emotional_shift_summary = _build_emotional_shift_summary(emotional_profile)
    sentiment_label = max(sentiment_votes.items(), key=lambda item: item[1])[0]
    return top_behaviors, emotional_profile, emotional_shift_summary, sentiment_label


def _build_emotional_shift_summary(emotional_profile: dict[str, float]) -> str:
    weighted = {
        "anxiety": emotional_profile.get("fear", 0.0) * 1.15,
        "self-doubt": emotional_profile.get("sadness", 0.0) * 1.05,
        "diminished confidence": emotional_profile.get("disgust", 0.0) * 0.9 + emotional_profile.get("anger", 0.0) * 0.7,
        "emotional fatigue": emotional_profile.get("surprise", 0.0) * 0.5 + emotional_profile.get("sadness", 0.0) * 0.4,
    }
    leading = sorted(weighted.items(), key=lambda item: item[1], reverse=True)[:3]
    descriptors = ", ".join(item[0] for item in leading[:-1])
    tail = leading[-1][0]
    state = f"{descriptors}, and {tail}" if descriptors else tail
    return (
        f"Your narrative reflects {state}. These responses can emerge when emotional safety feels uncertain; "
        "your feelings are valid, and clarity can begin with honoring what you noticed."
    )
