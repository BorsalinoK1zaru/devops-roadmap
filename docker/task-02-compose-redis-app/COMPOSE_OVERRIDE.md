# Docker Compose override

## Зачем нужен compose.override.yaml

`compose.override.yaml` используется для локальных dev-настроек.

Docker Compose по умолчанию читает:

```text
compose.yaml
compose.override.yaml
```

если оба файла есть в папке проекта.

## Базовый compose.yaml

`compose.yaml` содержит основную конфигурацию проекта:

- app;
- redis;
- volume;
- healthcheck;
- ports;
- environment.

## Локальный override

`compose.override.yaml` может переопределять часть настроек:

```yaml
services:
  app:
    environment:
      APP_ENV: "development"
      GUNICORN_LOG_LEVEL: "debug"
    volumes:
      - ./app.py:/app/app.py:ro
      - ./gunicorn.conf.py:/app/gunicorn.conf.py:ro
```

## Зачем нужен bind mount

Bind mount позволяет контейнеру видеть файл с хоста.

Это удобно в разработке, потому что можно менять код без пересборки image.

Пример:

```yaml
volumes:
  - ./app.py:/app/app.py:ro
```

Здесь локальный `app.py` подключается внутрь контейнера по пути `/app/app.py`.

## Production override

Для production можно использовать отдельный файл:

```bash
docker compose --env-file .env.prod.example -f compose.yaml -f compose.prod.yaml config
```

## Главное отличие dev и prod

Dev:

- может использовать bind mounts;
- может включать debug-логи;
- удобен для разработки.

Prod:

- не должен зависеть от локальных файлов;
- должен использовать готовый image;
- должен иметь более строгие настройки логирования.

## Главное правило

`compose.yaml` — базовая конфигурация.

`compose.override.yaml` — локальные dev-настройки.

`compose.prod.yaml` — production-настройки, которые подключаются явно через `-f`.