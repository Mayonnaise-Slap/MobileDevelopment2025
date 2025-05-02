from datetime import datetime
from typing import Optional, List

from sqlalchemy import Column, JSON
from sqlmodel import Field, SQLModel


class Story(SQLModel, table=True):
    __tablename__ = "stories"
    id: int = Field(primary_key=True)
    by: Optional[str]
    time: datetime
    kids: Optional[List[int]] | None = Field(default=None, sa_column=Column(JSON))

    title: Optional[str]
    url: Optional[str]
    score: Optional[int]
    descendants: Optional[int]


class Comment(SQLModel, table=True):
    __tablename__ = "comments"
    id: int = Field(primary_key=True)
    by: Optional[str]
    time: datetime
    kids: Optional[List[int]] | None = Field(default=None, sa_column=Column(JSON))

    text: Optional[str]
    parent: Optional[int]
