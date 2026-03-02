from __future__ import annotations

import asyncio

import nltk
from transformers import pipeline

from app.core.config import get_settings


class ModelRegistry:
    def __init__(self) -> None:
        self._classifier = None
        self._lock = asyncio.Lock()

    @property
    def classifier(self):
        if self._classifier is None:
            raise RuntimeError("ML classifier not loaded")
        return self._classifier

    async def load(self) -> None:
        if self._classifier is not None:
            return
        async with self._lock:
            if self._classifier is not None:
                return
            settings = get_settings()
            await asyncio.to_thread(nltk.download, "punkt", quiet=True)
            await asyncio.to_thread(nltk.download, "punkt_tab", quiet=True)
            self._classifier = await asyncio.to_thread(
                pipeline,
                task="zero-shot-classification",
                model=settings.model_name,
            )


model_registry = ModelRegistry()
