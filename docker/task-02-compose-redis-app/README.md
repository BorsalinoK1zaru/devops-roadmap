# Compose Redis Task App

## Описание

Flask-приложение, которое запускается через Docker Compose и использует Redis для хранения счётчика.

Проект показывает:

- сборку Python-приложения через Dockerfile;
- запуск нескольких сервисов через Docker Compose;
- использование Redis;
- healthcheck;
- env-файлы;
- Compose profiles;
- Compose override;
- запуск приложения не от root-пользователя.

## Сервисы

- `app` — Flask + Gunicorn
- `redis` — Redis 7 Alpine

## Endpoint-ы

| Endpoint | Описание |
|---|---|
| `/` | Главная HTML-страница |
| `/health` | Проверка работы приложения |
| `/config` | Текущая конфигурация из переменных окружения |
| `/redis-check` | Проверка подключения к Redis |
| `/counter` | Увеличение счётчика |
| `/reset` | Сброс счётчика |

## Переменные окружения

Смотри `.env.example`.

## Запуск dev-режима

docker compose --env-file .env.dev up -d --build

## Запуск debug-сервиса:

docker compose --env-file .env.dev --profile debug up -d

## Проверка

```bash
curl http://localhost:8070/health
curl http://localhost:8070/config
curl http://localhost:8070/redis-check
curl http://localhost:8070/counter
curl http://localhost:8070/reset
```

## Логи

```bash
docker compose logs app
docker compose logs redis
```

## Остановка

```bash
docker compose --env-file .env.dev down
```

## Production config check

Проверить production-конфигурацию без запуска:

docker compose --env-file .env.prod.example -f compose.yaml -f compose.prod.yaml config

## Volume

Redis использует named volume `redis-data`, который хранит данные отдельно от контейнера.

## Healthcheck

Redis проверяется через команду:

```bash
redis-cli ping
```

Если Redis отвечает `PONG`, сервис получает статус `healthy`.

## Документация проекта

DEBUGGING.md — диагностика проекта.
CLEANUP.md — безопасная очистка Docker.
DOCKERFILE_BEST_PRACTICES.md — лучшие практики Dockerfile.
COMPOSE_PROFILES.md — profiles и env-файлы.
COMPOSE_OVERRIDE.md — override-файлы и bind mounts.