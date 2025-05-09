import logging
from contextlib import asynccontextmanager
from datetime import datetime

import httpx
from sqlmodel.ext.asyncio.session import AsyncSession

from app.models import Story, Comment

API_BASE_URL = "https://hacker-news.firebaseio.com/v0"
logging.basicConfig(
    format="%(levelname)s [%(asctime)s] %(name)s - %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
    level=logging.INFO
)


@asynccontextmanager
async def get_http_client():
    try:
        async with httpx.AsyncClient(base_url=API_BASE_URL, timeout=60) as client:
            yield client
    finally:
        await client.aclose()



def build_nested_item_tree(items: list[dict]) -> list[dict]:
    id_map = {item["id"]: {**item, "replies": []} for item in items}

    roots = []

    for item in id_map.values():
        parent_id = item.get("parent")
        if parent_id and parent_id in id_map:
            id_map[parent_id]["replies"].append(item)
        else:
            roots.append(item)

    return roots


async def insert_item(item: dict, session: AsyncSession):
    item_type = item.get("type")
    item["time"] = convert_unix_time(item["time"])
    item_id = item.get("id")

    if item_type == "story":
        obj_class = Story
    elif item_type == "comment":
        obj_class = Comment
    else:
        return None

    existing = await session.get(obj_class, item_id)

    if existing:
        for key, value in item.items():
            setattr(existing, key, value)
        await session.commit()
        await session.refresh(existing)
        return existing
    else:
        obj = obj_class(**item)
        session.add(obj)
        await session.commit()
        return obj


def convert_unix_time(unix_time: int) -> datetime:
    return datetime.fromtimestamp(unix_time)
