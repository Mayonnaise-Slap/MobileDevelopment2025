import os

from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
from sqlmodel import SQLModel

DATABASE_URL = os.getenv("DATABASE_URL", 'postgresql+asyncpg://postgres:123@0.0.0.0:5432/postgres')

engine = create_async_engine(DATABASE_URL, echo=True, future=True)
AsyncSessionLocal = sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)


async def get_session() -> AsyncSession:
    async with AsyncSessionLocal() as session:
        yield session


async def init_db():
    import app.models
    async with engine.begin() as conn:
        await conn.run_sync(SQLModel.metadata.create_all)
