# Диагностика проблем на сервере

## Проект

Сервер: self-hosted Ubuntu Server  
Проект: docker/task-02-compose-redis-app  
Запуск: Docker Compose  
Адрес приложения на сервере: http://127.0.0.1:8070

## Основные скрипты

Все команды выполняются из корня репозитория:

    ./sprint-02-linux-vps/scripts/day29/server-status.sh
    ./sprint-02-linux-vps/scripts/day29/server-healthcheck.sh
    ./sprint-02-linux-vps/scripts/day29/server-logs.sh app
    ./sprint-02-linux-vps/scripts/day29/server-logs.sh redis
    ./sprint-02-linux-vps/scripts/day29/server-restart.sh app
    ./sprint-02-linux-vps/scripts/day29/server-deploy.sh

## Частые проблемы

### 1. Deploy script пишет, что в репозитории есть локальные изменения

Проверить состояние репозитория:

    git status
    git diff

Если файл был случайно изменён прямо на сервере, его можно откатить:

    git restore путь/к/файлу

Важно: отслеживаемые Git-файлы лучше менять локально на ноутбуке, потом делать commit, push и только после этого pull на сервере.

Сервер должен получать готовую версию проекта из GitHub, а не быть местом разработки.

### 2. App container постоянно перезапускается

Проверить логи приложения:

    ./sprint-02-linux-vps/scripts/day29/server-logs.sh app 200

Частые причины:
- пустые переменные окружения;
- неправильный APP_PORT;
- неправильные настройки Gunicorn;
- ошибка импорта приложения;
- ошибка в app.py;
- проблема с переменными из .env.server.

### 3. Healthcheck падает сразу после deploy

Контейнер может быть запущен, но приложение внутри него ещё не готово принимать запросы.

Поэтому deploy script должен делать несколько попыток проверки /health, а не один curl сразу после старта контейнера.

Признак такой проблемы:

    Container Started
    curl: connection reset by peer

Это не всегда значит, что приложение сломано. Иногда ему просто нужно несколько секунд на запуск.

### 4. Redis healthy, но приложение не может подключиться к Redis

Проверить состояние контейнеров:

    docker compose --env-file .env.server ps

Проверить Redis напрямую:

    docker compose --env-file .env.server exec redis redis-cli ping

Ожидаемый ответ:

    PONG

Внутри Docker Compose приложение должно обращаться к Redis по имени сервиса:

    REDIS_HOST=redis

Не нужно указывать localhost, потому что localhost внутри app-контейнера означает сам app-контейнер, а не Redis.

### 5. В .env.server появились Windows-переносы строк

Проверить файл:

    cat -A .env.server

Если в конце строк видны символы ^M, значит файл содержит Windows-переносы строк CRLF.

Исправить:

    sed -i 's/\r$//' .env.server

После исправления строки должны заканчиваться только символом $.

### 6. Проверка безопасности портов

Текущая безопасная схема публикации приложения:

    127.0.0.1:8070 -> app container:5000

Это значит, что приложение доступно только с самого сервера.

Redis не должен быть опубликован наружу.

Нельзя открывать в интернет:

    6379

Redis должен быть доступен только внутри Docker Compose network.

### 7. Проверка портов на сервере

Посмотреть listening ports:

    ss -tulpn

Для текущего этапа нормально, если наружу слушает только SSH:

    0.0.0.0:22
    [::]:22

Приложение должно слушать локально:

    127.0.0.1:8070

### 8. Known issue

Сейчас в /config может отображаться:

    environment=development

Даже если серверный .env.server использует server-значения.

Это не блокирует деплой, потому что основные проверки проходят:

    /health -> ok
    /redis-check -> connected
    /counter -> работает
    Redis PING -> PONG

К этой проблеме можно вернуться позже перед этапом Nginx/production-настройки.
