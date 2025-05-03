import asyncio

from app.db.session import get_session
from app.task_manager.utils import insert_item
from app.task_manager.hn_client import get_new_stories, parse_item_array
from app.task_manager.utils import get_http_client
from app.celery_worker import celery_app


@celery_app.task
def fetch_and_store_new_stories():
    async def _fetch_and_store_new_stories():
        async with get_http_client() as client:
            story_ids = await get_new_stories(client)
            items = await parse_item_array(story_ids, client)

        async with get_session() as session:
            for item in items:
                await insert_item(item, session)

    asyncio.run(_fetch_and_store_new_stories())


@celery_app.task
def mass_load(items: list):
    async def load_items():
        async with get_session() as session:
            for item in items:
                await insert_item(item, session)

    asyncio.run(load_items())
