import asyncpg
import asyncio

DB_CONFIG = {
    "user": "recipesuser",
    "password": "recipespass",
    "database": "recipesdb",
    "host": "postgres",
    "port": 5432
}

async def get_db():
    conn = await asyncpg.connect(**DB_CONFIG)
    try:
        yield conn
    finally:
        await conn.close()
