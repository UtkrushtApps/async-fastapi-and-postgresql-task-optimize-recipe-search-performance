from fastapi import FastAPI
from app.routes.api import router as api_router

app = FastAPI(title="Async Recipes API")
app.include_router(api_router)
