import httpx
from contextlib import asynccontextmanager

API_BASE_URL = "https://hacker-news.firebaseio.com/v0"

@asynccontextmanager
async def get_http_client():
    async with httpx.AsyncClient(base_url=API_BASE_URL, timeout=5) as client:
        yield client
