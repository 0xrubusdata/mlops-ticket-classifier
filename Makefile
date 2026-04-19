.PHONY: help setup install test lint format train api clean

help:  ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

setup:  ## Install Poetry and dependencies
	poetry install --with dev

install:  ## Install only production dependencies
	poetry install --only main

lint:  ## Run linting
	poetry run ruff check src tests
	poetry run isort --check-only src tests

format:  ## Format code
	poetry run ruff format src tests
	poetry run isort src tests

test:  ## Run tests
	poetry run pytest tests/ -v

train:  ## Run training pipeline
	poetry run python -m src.training.train

api:  ## Start FastAPI development server
	poetry run uvicorn src.api.main:app --reload --port 8000

dvc-repro:  ## Reproduce DVC pipeline
	poetry run dvc repro

clean:  ## Clean cache and temp files
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type d -name ".pytest_cache" -exec rm -rf {} +
	rm -rf .ruff_cache

up:  ## Start services with Docker Compose
	docker compose up --build

down:  ## Stop services
	docker compose down