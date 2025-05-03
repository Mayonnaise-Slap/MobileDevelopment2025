from datetime import datetime

from app.models import Story, Comment
from app.task_manager.hn_client import get_item_by_id
from app.task_manager.utils import get_http_client
from fastapi import HTTPException
from sqlmodel.ext.asyncio.session import AsyncSession


def convert_unix_time(unix_time: int) -> datetime:
    return datetime.fromtimestamp(unix_time)


# TODO add function to create or update object

async def insert_item(item: dict, session: AsyncSession):
    item_type = item.get("type")
    item["time"] = convert_unix_time(item["time"])

    if item_type == "story":
        obj = Story(**item)
    elif item_type == "comment":
        obj = Comment(**item)
    else:
        return None

    session.add(obj)
    await session.commit()

    return obj


async def fetch_or_get_item(item_id: int, session):
    story = await session.get(Story, item_id)
    comment = await session.get(Comment, item_id)

    if story or comment:
        return story or comment

    async with get_http_client() as client:
        data = await get_item_by_id(item_id, client)

    if not data or "type" not in data or "id" not in data:
        raise HTTPException(status_code=404, detail="Item not found or invalid")

    obj = await insert_item(data, session)

    return obj
