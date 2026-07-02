# Dockerfile best practices

## 1. Правильный порядок слоёв

Сначала копируются файлы, которые меняются редко:

```dockerfile
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
```

Потом копируется код приложения:

```dockerfile
COPY app.py .
COPY gunicorn.conf.py .
```

Так Docker лучше использует cache.

Если изменился только `app.py`, зависимости не нужно устанавливать заново.

## 2. Не запускать приложение от root

В Dockerfile создаётся отдельный пользователь:

```dockerfile
RUN groupadd --system appgroup \
    && useradd --system --gid appgroup --home-dir /app appuser
```

Потом приложение запускается от него:

```dockerfile
USER appuser
```

Это безопаснее, чем запускать приложение от root.

## 3. Python ENV-переменные

```dockerfile
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
```

`PYTHONDONTWRITEBYTECODE=1` отключает создание `.pyc`-файлов.

`PYTHONUNBUFFERED=1` помогает видеть логи сразу в Docker logs.

## 4. Использовать .dockerignore

`.dockerignore` не даёт лишним файлам попадать в build context.

Примеры лишних файлов:

```text
.git
.env
__pycache__
.venv
README.md
```

## 5. Использовать slim base image

```dockerfile
FROM python:3.12-slim
```

`slim`-образ обычно меньше полного Python-образа.

## 6. Проверять пользователя внутри контейнера

```bash
docker compose exec app id
```

Если приложение работает не от root, это лучше для безопасности.

## 7. Смотреть историю image

```bash
docker image history python-compose-task:task2
```

Эта команда помогает понять, из каких слоёв состоит image.

## 8. Пересборка без cache

```bash
docker compose build --no-cache app
```

Эта команда полезна, когда нужно убедиться, что image собрался полностью заново.
