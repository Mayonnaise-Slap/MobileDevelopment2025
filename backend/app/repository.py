from fastapi import HTTPException
from sqlmodel import select
from sqlmodel.ext.asyncio.session import AsyncSession

from app.models import Story, Comment
from app.task_manager.hn_client import get_item_by_id, traverse_item_to_array
from app.task_manager.utils import get_http_client, build_nested_item_tree
from app.task_manager.tasks import mass_load
from app.task_manager.utils import insert_item


async def cached_fetch_or_get_item(item_id: int, session):
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


async def dynamic_fetch_item(item_id: int, session):
    async with get_http_client() as client:
        data = await get_item_by_id(item_id, client)

    if not data or "type" not in data or "id" not in data:
        raise HTTPException(status_code=404, detail="Item not found or invalid")

    obj = await insert_item(data, session)

    return obj


async def fetch_comment_tree(comment_ids: list[int], session: AsyncSession, depth: int = 1, max_depth: int = 3):
    if depth > max_depth or not comment_ids:
        return []

    stmt = select(Comment).where(Comment.id.in_(comment_ids))
    result = await session.exec(stmt)
    comments = result.all()

    comment_list = []
    for comment in comments:
        comment_data = comment.dict()
        comment_data["replies"] = await fetch_comment_tree(comment.kids or [], session, depth + 1, max_depth)
        comment_list.append(comment_data)

    return comment_list


async def cached_get_story_with_comments(story_id: int, session: AsyncSession):
    story = await session.get(Story, story_id)
    if not story:
        return {"error": "Story not found"}

    story_data = story.model_dump(Story)
    story_data["comments"] = await fetch_comment_tree(story.kids or [], session)

    return story_data


async def fetch_story_comments(story_id: int, session: AsyncSession):
    async with get_http_client() as client:
        items = await traverse_item_to_array(story_id, client, depth=1)
    mass_load.delay(items)

    nested_tree = build_nested_item_tree(items)

    return nested_tree
