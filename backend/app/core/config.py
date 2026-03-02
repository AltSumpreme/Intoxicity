from functools import lru_cache
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_name: str = "Intoxicity API"
    app_env: str = "development"
    app_host: str = "0.0.0.0"
    app_port: int = 8000
    database_url: str = "postgresql+asyncpg://intoxicity:intoxicity@db:5432/intoxicity"
    cors_origins: list[str] = ["*"]
    model_name: str = "valhalla/distilbart-mnli-12-3"

    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")


@lru_cache

def get_settings() -> Settings:
    return Settings()
