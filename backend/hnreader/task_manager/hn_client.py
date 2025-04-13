import asyncio
import json
import time
from random import random
from typing import List

import httpx

from hnreader.task_manager.utils import get_http_client


async def get_item_by_id(item_id: int, client: httpx.AsyncClient):
    await asyncio.sleep(random() / 10)
    response = await client.get(f"/item/{item_id}.json")
    return response.json()


async def parse_item_array(items: List[int], client: httpx.AsyncClient):
    tasks = [get_item_by_id(i, client) for i in items]

    return await asyncio.gather(*tasks)


async def traverse_item(item_id: int, client: httpx.AsyncClient, depth=0):
    node = await get_item_by_id(item_id, client)

    if depth == 0:
        return node

    kids = node.get('kids', [])
    node['kids'] = await parse_item_array(kids, client)

    return node


async def get_user_data(user_id: str, client: httpx.AsyncClient):
    response = await client.get(f"/user/{user_id}.json")
    return response.json()


async def traverse_user_data(user_id: str, client: httpx.AsyncClient):
    user = await get_user_data(user_id, client)

    submitions = user.get('submitted', [])

    user['submitted'] = await parse_item_array(submitions, client)
    return user


async def get_top_stories(client: httpx.AsyncClient) -> List[int]:
    response = await client.get("/topstories.json")
    return response.json()


async def get_new_stories(client: httpx.AsyncClient) -> List[int]:
    response = await client.get("/newstories.json")
    return response.json()


async def get_best_stories(client: httpx.AsyncClient) -> List[int]:
    response = await client.get("/beststories.json")
    return response.json()
