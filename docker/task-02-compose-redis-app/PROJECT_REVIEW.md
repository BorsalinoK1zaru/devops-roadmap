# Project review

## Project

`task-02-compose-redis-app`

## Description

Flask + Redis project running with Docker Compose.

## Main features

- Flask app served by Gunicorn.
- Redis service.
- Counter endpoint using Redis.
- Healthcheck for Redis.
- Environment variables through env files.
- Dev and prod env examples.
- Debug service through Compose profiles.
- Dev override through `compose.override.yaml`.
- Production override through `compose.prod.yaml`.
- Non-root application user inside Docker image.
- Project documentation.

## Main commands

### Dev start

```bash
docker compose --env-file .env.dev up -d --build
Dev check
curl http://localhost:8070/health
curl http://localhost:8070/config
curl http://localhost:8070/redis-check
curl http://localhost:8070/counter
Debug profile
docker compose --env-file .env.dev --profile debug up -d
docker compose --env-file .env.dev exec debug-redis-cli redis-cli -h redis ping
Prod config check
docker compose --env-file .env.prod.example -f compose.yaml -f compose.prod.yaml config
Stop
docker compose --env-file .env.dev down
```
## What was checked

- App starts successfully.
- Redis starts successfully.
- Redis healthcheck works.
- App connects to Redis.
- Counter endpoint works.
- Debug profile works.
- Production config is generated correctly.
- App runs as non-root user.
- Result

The project is ready as a Sprint 1 Docker Compose mini-project.
