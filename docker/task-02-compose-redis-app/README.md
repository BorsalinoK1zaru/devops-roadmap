# Compose Redis Task App

## Описание

Flask-приложение, которое запускается через Docker Compose и использует Redis для хранения счётчика.

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

## Запуск

```bash
cp .env.example .env
docker compose up -d --build
```

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
docker compose down
```

## Volume

Redis использует named volume `redis-data`, который хранит данные отдельно от контейнера.

## Healthcheck

Redis проверяется через команду:

```bash
redis-cli ping
```

Если Redis отвечает `PONG`, сервис получает статус `healthy`.