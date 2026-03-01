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
    "verbal abuse",
    "jealousy aggression",
    "healthy communication",
]

EMOTION_LABELS = ["anger", "sadness", "fear", "joy", "disgust", "surprise"]
SENTIMENT_LABELS = ["positive sentiment", "negative sentiment"]


async def _classify(text: str, labels: list[str]) -> dict[str, float]:
    classifier = model_registry.classifier

    def run() -> dict[str, float]:
        result = classifier(text, labels, multi_label=True)
        return {label: float(score) for label, score in zip(result["labels"], result["scores"], strict=False)}

    return await asyncio.to_thread(run)


async def analyze_sentences(content: str) -> tuple[list[dict], dict[str, float], str]:
    sentences = [segment.strip() for segment in nltk.sent_tokenize(content) if segment.strip()]

    if not sentences:
        return [], {label: 0.0 for label in EMOTION_LABELS}, "negative sentiment"

    emotion_totals = {label: 0.0 for label in EMOTION_LABELS}
    sentiment_votes = defaultdict(int)
    behavior_candidates = []

    for sentence in sentences:
        behavior_scores, emotion_scores, sentiment_scores = await asyncio.gather(
            _classify(sentence, BEHAVIOR_LABELS),
            _classify(sentence, EMOTION_LABELS),
            _classify(sentence, SENTIMENT_LABELS),
        )

        top_behavior = max(behavior_scores.items(), key=lambda item: item[1])
        top_sentiment = max(sentiment_scores.items(), key=lambda item: item[1])[0]

        sentiment_votes[top_sentiment] += 1

        for emotion in EMOTION_LABELS:
            emotion_totals[emotion] += emotion_scores.get(emotion, 0.0)

        if top_behavior[0] != "healthy communication" and top_behavior[1] >= 0.4:
            behavior_candidates.append(
                {
                    "behavior": top_behavior[0],
                    "severity": round(top_behavior[1], 4),
                    "sentence": sentence,
                    "emotion_scores": {k: round(v, 4) for k, v in emotion_scores.items()},
                    "sentiment_label": top_sentiment,
                }
            )

    emotional_profile = {
        label: round(emotion_totals[label] / len(sentences), 4) for label in EMOTION_LABELS
    }

    grouped_best = {}
    for candidate in behavior_candidates:
        behavior = candidate["behavior"]
        if behavior not in grouped_best or candidate["severity"] > grouped_best[behavior]["severity"]:
            grouped_best[behavior] = candidate

    top_behaviors = sorted(grouped_best.values(), key=lambda item: item["severity"], reverse=True)[:5]

    sentiment_label = max(sentiment_votes.items(), key=lambda item: item[1])[0]
    return top_behaviors, emotional_profile, sentiment_label
