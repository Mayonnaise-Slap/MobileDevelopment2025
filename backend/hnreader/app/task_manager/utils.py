import logging
from contextlib import asynccontextmanager

import httpx

API_BASE_URL = "https://hacker-news.firebaseio.com/v0"
logging.basicConfig(
    format="%(levelname)s [%(asctime)s] %(name)s - %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
    level=logging.INFO
)


@asynccontextmanager
async def get_http_client():
    async with httpx.AsyncClient(base_url=API_BASE_URL, timeout=10) as client:
        yield client
