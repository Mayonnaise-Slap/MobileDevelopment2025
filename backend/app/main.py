from contextlib import asynccontextmanager

from app.db.session import get_session, init_db
from app.models import Story, Comment
from app.repository import convert_unix_time
from app.repository import fetch_or_get_item
from app.task_manager.hn_client import get_item_by_id
from app.task_manager.utils import get_http_client
from fastapi import APIRouter, Depends
from fastapi import FastAPI
from sqlmodel.ext.asyncio.session import AsyncSession


@asynccontextmanager
async def lifespan(app: FastAPI):
    await init_db()
    yield


app = FastAPI(lifespan=lifespan)


@app.get("/")
async def root():
    return {"message": "Hello from FastAPI with async DB!"}


router = APIRouter()


@router.get("/items/{item_id}")
async def test_get_item(item_id: int, session: AsyncSession = Depends(get_session)):
    return await fetch_or_get_item(item_id, session)


app.include_router(router)
