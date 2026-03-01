# Intoxicity

Intoxicity is an emotionally intelligent AI-powered journaling application designed to help users understand difficult relationship dynamics with compassion, clarity, and confidence.

## Monorepo Structure

```text
intoxicity/
├── backend/
├── frontend/
├── docker-compose.yml
├── .env.example
└── README.md
```

## Architecture Diagram

```text
┌─────────────────────────── Flutter App ───────────────────────────┐
│ Journal Screen → Analysis Screen → History Screen                 │
│   (Riverpod state + animated UI + emotion visualizations)         │
└──────────────────────────────┬─────────────────────────────────────┘
                               │ HTTP (REST)
                               ▼
┌──────────────────────────── FastAPI API ───────────────────────────┐
│ POST /api/v1/analyze                                               │
│ GET  /api/v1/history                                                │
│ - Async service layer                                               │
│ - Single zero-shot model loaded once on startup                    │
│ - Scoring engine + sentence evidence extraction                    │
└──────────────────────────────┬─────────────────────────────────────┘
                               │ SQLAlchemy Async ORM
                               ▼
┌──────────────────────────── PostgreSQL ────────────────────────────┐
│ Stores journal content, toxicity score, risk level, profile,       │
│ behavior evidence, and timestamps                                   │
└─────────────────────────────────────────────────────────────────────┘
```

## Single-Model ML Explanation

The backend loads one model only at startup:

- `valhalla/distilbart-mnli-12-3`

Using zero-shot classification with custom labels, this single model powers:

1. Behavior classification
2. Emotion profiling
3. Sentiment labeling

This keeps the architecture simple and production-friendly while still expressive.

## Sentence-Level Extraction

1. Journal text is split into sentences using NLTK sentence tokenization.
2. Each sentence is classified against:
   - Behavior labels
   - Emotion labels
   - Sentiment labels
3. Behaviors are ignored when:
   - label = `healthy communication`
   - score < `0.4`
4. Evidence is grouped by behavior category and highest severity sentence is kept.
5. Top 5 harmful behaviors are returned in descending severity.

## Toxicity Scoring Math

- `behavior_score = average(severity(top_behaviors))`
- `emotional_distress_score = fear*0.3 + sadness*0.3 + anger*0.2 + disgust*0.2`
- `toxicity_score = (behavior_score*0.7 + emotional_distress_score*0.3) * 100`

Risk levels:

- 0–25: Healthy
- 26–50: Concerning
- 51–75: High Toxicity
- 76–100: Severe Toxicity

## Backend Setup (Local)

```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

## Docker Setup

```bash
cp .env.example .env
docker compose up --build
```

API endpoints:

- `POST http://localhost:8000/api/v1/analyze`
- `GET http://localhost:8000/api/v1/history`

## Flutter Setup

```bash
cd frontend
flutter pub get
flutter run --dart-define=API_URL=http://localhost:8000/api/v1
```

## API Contract

### Request

```json
{
  "content": "journal entry text"
}
```

### Response

```json
{
  "toxicity_score": 63.8,
  "risk_level": "High Toxicity",
  "sentiment": {"label": "negative sentiment"},
  "emotional_profile": {
    "anger": 0.66,
    "sadness": 0.71,
    "fear": 0.57,
    "joy": 0.12,
    "disgust": 0.41,
    "surprise": 0.28
  },
  "top_behaviors": [
    {
      "behavior": "gaslighting",
      "severity": 0.84,
      "sentence": "...",
      "emotion_scores": {"anger": 0.5, "sadness": 0.6},
      "sentiment_label": "negative sentiment"
    }
  ]
}
```

## Future Improvements

- Add auth + encrypted journal storage.
- Introduce model quantization and inference caching.
- Add trend analytics and healing journey insights over time.
- Add multilingual support and locale-specific behavioral nuance.
- Add clinician export mode and PDF summary reports.
