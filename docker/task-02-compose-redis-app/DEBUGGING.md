# Debugging Docker Compose project

## Полезные команды

```bash
docker compose ps
docker compose logs app
docker compose logs --tail=20 app
docker compose logs -f app
docker compose exec app sh
docker compose exec redis redis-cli ping
docker compose config
docker compose top
docker stats --no-stream python-compose-task2 task2-redis
docker inspect task2-redis --format='{{json .State.Health}}'
```

## Типовые проблемы

### App не подключается к Redis

Проверить текущую конфигурацию приложения:

```bash
curl http://localhost:8070/config
```

Проверить Redis:

```bash
docker compose exec redis redis-cli ping
```

Проверить DNS service name внутри app-контейнера:

```bash
docker compose exec app python -c "import socket; print(socket.gethostbyname('redis'))"
```

Правильное значение в `.env`:

```env
REDIS_HOST=redis
```

После изменения `.env` нужно пересоздать app-контейнер:

```bash
docker compose up -d --force-recreate app
```

### Изменения в коде не применились

Пересобрать image:

```bash
docker compose up -d --build
```

Полностью пересобрать без cache:

```bash
docker compose build --no-cache
docker compose up -d
```

### Нужно посмотреть итоговый compose.yaml

```bash
docker compose config
```

Эта команда показывает итоговую конфигурацию после подстановки переменных из `.env`.

### Redis unhealthy

Проверить healthcheck:

```bash
docker inspect task2-redis --format='{{json .State.Health}}'
```

Проверить Redis напрямую:

```bash
docker compose exec redis redis-cli ping
```

Ожидаемый ответ:

```text
PONG
```

### Нужно посмотреть процессы внутри сервисов

```bash
docker compose top
```

Эта команда показывает процессы, которые запущены внутри контейнеров проекта.

### Нужно посмотреть потребление ресурсов

```bash
docker stats --no-stream python-compose-task2 task2-redis
```

Эта команда показывает CPU, RAM, сеть, дисковые операции и количество процессов контейнеров.

### Нужно зайти внутрь app-контейнера

```bash
docker compose exec app sh
```

Полезные команды внутри app-контейнера:

```bash
pwd
ls -la
printenv | grep APP
printenv | grep REDIS
python --version
python -c "import socket; print(socket.gethostbyname('redis'))"
exit
```

### Нужно проверить Redis изнутри Redis-контейнера

```bash
docker compose exec redis redis-cli ping
docker compose exec redis redis-cli GET day11_counter
```

### После изменения `.env` приложение не видит новые значения

Если изменить `.env`, уже созданный контейнер продолжит использовать старые значения переменных окружения.

Нужно пересоздать контейнер:

```bash
docker compose up -d --force-recreate app
```

Если менялся код приложения или Dockerfile, лучше пересобрать image:

```bash
docker compose up -d --build
```

### Контейнеры нужно остановить

```bash
docker compose down
```

Эта команда остановит и удалит контейнеры проекта и сеть Compose.

Named volumes без флага `-v` не удаляются.

### Нужно удалить контейнеры вместе с volume

```bash
docker compose down -v
```

Осторожно: эта команда удалит named volume и данные Redis.
