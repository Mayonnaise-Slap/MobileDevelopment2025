from contextlib import asynccontextmanager

from fastapi import APIRouter, Depends
from fastapi import FastAPI
from sqlalchemy import text
from sqlmodel.ext.asyncio.session import AsyncSession

from app.db.session import get_session, init_db
from app.repository import cached_fetch_or_get_item, fetch_story_comments


@asynccontextmanager
async def lifespan(app: FastAPI):
    await init_db()
    yield


app = FastAPI(lifespan=lifespan)


@app.get("/")
async def root():
    return {"message": "Hello from FastAPI with async DB!"}


@app.get("/health")
async def health_check(session: AsyncSession = Depends(get_session)):
    try:
        await session.execute(text("select 1"))
        return {"status": "ok"}
    except Exception as e:
        return {"status": "error", "details": str(e)}


router = APIRouter()


@router.get("/items/{item_id}")
async def test_get_item(item_id: int, session: AsyncSession = Depends(get_session)):
    return await cached_fetch_or_get_item(item_id, session)


@router.get("/items/{item_id}/recursive")
async def test_get_item_recursive(item_id: int, session: AsyncSession = Depends(get_session)):
    return await fetch_story_comments(item_id, session)

app.include_router(router)
