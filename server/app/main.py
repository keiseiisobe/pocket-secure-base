"""DeepBreath Strategic Planner API."""

import logging
from functools import lru_cache

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.schemas import PlanRequest, PlanResponse
from app.services.planner import run_strategic_planner
from app.settings import Settings

logging.basicConfig(level=logging.INFO)


@lru_cache
def get_settings() -> Settings:
    return Settings()


def create_app() -> FastAPI:
    settings = get_settings()
    application = FastAPI(title="DeepBreath Strategic Planner", version="0.1.0")

    application.add_middleware(
        CORSMiddleware,
        allow_origins=settings.cors_origins,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    @application.get("/health")
    async def health() -> dict[str, str]:
        return {"status": "ok"}

    @application.post("/v1/plan", response_model=PlanResponse)
    async def plan_route(body: PlanRequest) -> PlanResponse:
        return await run_strategic_planner(body, get_settings())

    return application


app = create_app()
