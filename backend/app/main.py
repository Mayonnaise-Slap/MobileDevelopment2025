from contextlib import asynccontextmanager

from fastapi import APIRouter, Depends
from fastapi import FastAPI
from fastapi.responses import JSONResponse
from sqlalchemy import text
from sqlmodel.ext.asyncio.session import AsyncSession

from app.db.session import get_session, init_db
from app.repository import ProjectRepository


@asynccontextmanager
async def lifespan(app: FastAPI):
    await init_db()
    yield


app = FastAPI(lifespan=lifespan)


@app.get("/")
async def root():
    return {"message": "Hello from FastAPI with async DB!"}


@app.get("/health")
async def health_check(session: Depends = Depends(get_session)):
    try:
        await session.execute(text("select 1"))
        return JSONResponse({"status": "ok"}, 200)
    except Exception as e:
        return JSONResponse({"status": "error", "details": str(e)}, 500)


router_v1 = APIRouter(prefix='/api/v1')


@router_v1.get("/items/{item_id}")
async def get_item(item_id: int, session: AsyncSession = Depends(get_session)):
    return await ProjectRepository().get_story(session, item_id)


@router_v1.get("/items/{item_id}/recursive")
async def get_item_recursive(item_id: int, session: AsyncSession = Depends(get_session)):
    return await ProjectRepository().load_thread(session, item_id)


@router_v1.get("/topstories")
async def get_top_stories(session: AsyncSession = Depends(get_session)):
    return await ProjectRepository().get_top_stories(session)


@router_v1.get("/newstories")
async def get_new_stories(session: AsyncSession = Depends(get_session)):
    return await ProjectRepository().get_new_stories(session)


# TODO add list views for posts to optimize db connections
# TODO add fun stuff

app.include_router(router_v1)
