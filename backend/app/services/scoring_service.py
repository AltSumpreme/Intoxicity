from __future__ import annotations


def compute_toxicity_score(top_behaviors: list[dict], emotional_profile: dict[str, float]) -> tuple[float, str]:
    behavior_score = (
        sum(item["severity"] for item in top_behaviors) / len(top_behaviors) if top_behaviors else 0.0
    )

    emotional_distress_score = (
        emotional_profile.get("fear", 0.0) * 0.3
        + emotional_profile.get("sadness", 0.0) * 0.3
        + emotional_profile.get("anger", 0.0) * 0.2
        + emotional_profile.get("disgust", 0.0) * 0.2
    )

    toxicity_score = round((behavior_score * 0.7 + emotional_distress_score * 0.3) * 100, 2)

    if toxicity_score <= 25:
        risk_level = "Healthy"
    elif toxicity_score <= 50:
        risk_level = "Concerning"
    elif toxicity_score <= 75:
        risk_level = "High Toxicity"
    else:
        risk_level = "Severe Toxicity"

    return toxicity_score, risk_level
