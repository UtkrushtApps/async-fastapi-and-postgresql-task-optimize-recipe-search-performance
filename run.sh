#!/bin/bash
set -eu
cd /root/task
echo "Starting Recipes containers..."
docker-compose up -d
# Wait for PostgreSQL to be ready
attempts=0
max_attempts=20
until docker exec pg_recipes pg_isready -U recipesuser -d recipesdb || [ $attempts -eq $max_attempts ]; do
    echo "Waiting for postgres... ($((attempts+1))/$max_attempts)"
    sleep 2
    attempts=$((attempts+1))
done
if [ $attempts -eq $max_attempts ]; then
    echo "Error: PostgreSQL did not become ready in time."
    docker-compose logs postgres
    exit 1
fi

echo "PostgreSQL is ready. Checking FastAPI app..."
attempts=0
max_attempts=15
until curl -sf http://localhost:8000/docs || [ $attempts -eq $max_attempts ]; do
    echo "Waiting for FastAPI app... ($((attempts+1))/$max_attempts)"
    sleep 2
    attempts=$((attempts+1))
done
if [ $attempts -eq $max_attempts ]; then
    echo "Error: FastAPI app did not respond."
    docker-compose logs fastapi
    exit 2
fi

echo "Deployment successful. Recipes API is up and running."
docker-compose ps
