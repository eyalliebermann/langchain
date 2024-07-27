from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    openai_api_key: str

settings = Settings()

def get_settings():
    return settings