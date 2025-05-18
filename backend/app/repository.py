from sqlmodel import select
from sqlmodel.ext.asyncio.session import AsyncSession

from app.models import ListHolder
from app.models import Story
from app.task_manager.utils import recursive_get


class ProjectRepository:
    async def get_top_stories(self, session: AsyncSession):
        res = (await session.execute(select(ListHolder))).scalars().first()
        return res.trending_ids if res else []

    async def get_new_stories(self, session: AsyncSession):
        res = (await session.execute(select(ListHolder))).scalars().first()
        return res.new_ids if res else []

    async def get_story(self, session: AsyncSession, story_id: int):
        res = await session.get(Story, story_id)
        return res

    async def load_thread(self, session: AsyncSession, story_id: int):
        story_obj = await session.get(Story, story_id)
        story_obj = story_obj.model_dump()

        kids = story_obj.get('kids', [])
        kids_arr = []
        for kid in kids:
            kids_arr.append(await recursive_get(kid, 2, session))

        story_obj["kids"] = kids_arr
        return story_obj
