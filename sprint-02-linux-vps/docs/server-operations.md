# Операции на сервере

## Подключиться к серверу

    ssh devops-server

## Перейти в репозиторий

    cd ~/projects/devops-roadmap

## Задеплоить последнюю версию проекта

    ./sprint-02-linux-vps/scripts/day29/server-deploy.sh

## Проверить состояние проекта

    ./sprint-02-linux-vps/scripts/day29/server-status.sh

## Проверить работоспособность приложения

    ./sprint-02-linux-vps/scripts/day29/server-healthcheck.sh

## Посмотреть логи

Логи приложения:

    ./sprint-02-linux-vps/scripts/day29/server-logs.sh app

Логи Redis:

    ./sprint-02-linux-vps/scripts/day29/server-logs.sh redis

Последние 200 строк логов приложения:

    ./sprint-02-linux-vps/scripts/day29/server-logs.sh app 200

## Перезапустить только приложение

    ./sprint-02-linux-vps/scripts/day29/server-restart.sh app

## Ручные Docker Compose команды

Перейти в папку проекта:

    cd ~/projects/devops-roadmap/docker/task-02-compose-redis-app

Проверить сервисы:

    docker compose --env-file .env.server ps

Посмотреть логи приложения:

    docker compose --env-file .env.server logs --tail=100 app

Запустить или пересобрать проект:

    docker compose --env-file .env.server up -d --build

Остановить и удалить контейнеры проекта:

    docker compose --env-file .env.server down

## Правила безопасности

- Не коммитить .env.server.
- Не редактировать tracked-файлы проекта прямо на сервере.
- Не открывать Redis в интернет.
- Не запускать destructive cleanup-команды без проверки volumes.
- Не делать docker volume prune без понимания, какие данные будут удалены.
- Все изменения кода делать локально, затем commit, push и pull на сервере.
