# Docker cleanup guide

## Проверить использование диска

```bash
docker system df
docker system df -v
```

`docker system df` показывает, сколько места занимают Docker images, containers, volumes и build cache.

`docker system df -v` показывает более подробную информацию.

## Посмотреть images

```bash
docker image ls
docker images
docker image ls -f dangling=true
```

`docker image ls` показывает список Docker images.

`docker image ls -f dangling=true` показывает dangling images, то есть images без нормального тега.

## Посмотреть containers

```bash
docker ps
docker ps -a
```

`docker ps` показывает только запущенные контейнеры.

`docker ps -a` показывает все контейнеры, включая остановленные.

## Посмотреть volumes

```bash
docker volume ls
```

Volumes нужно удалять осторожно, потому что в них могут храниться данные Redis, PostgreSQL и других сервисов.

## Посмотреть build cache

```bash
docker builder du
```

Если команда не сработала, можно использовать:

```bash
docker system df
```

## Удалить stopped containers

```bash
docker container prune
```

Эта команда удаляет остановленные контейнеры.

Она не удаляет запущенные контейнеры.

## Удалить dangling images

```bash
docker image prune
```

Эта команда удаляет dangling images.

Dangling images часто выглядят так:

```text
<none>    <none>
```

## Удалить build cache

```bash
docker builder prune
```

Эта команда удаляет build cache.

После этого следующие сборки Docker image могут идти дольше, потому что Docker будет заново выполнять шаги сборки.

## Удалить один tag image

Пример:

```bash
docker image rm python-compose-task:day15
```

Если у одного image есть несколько tags, удаление одного tag не обязательно удаляет сам image.

## Осторожно с volumes

Не выполнять без понимания последствий:

```bash
docker volume prune
docker system prune --volumes
docker compose down -v
```

Volumes могут хранить данные Redis, PostgreSQL и других сервисов.

Удаление volume может привести к потере данных.

## Осторожно с полной очисткой

Не выполнять без необходимости:

```bash
docker system prune -a
docker system prune -a --volumes
```

`docker system prune -a` может удалить все unused images.

`docker system prune -a --volumes` может удалить ещё и volumes.

## Безопасный порядок очистки

Сначала посмотреть состояние:

```bash
docker system df
docker image ls
docker ps -a
docker volume ls
```

Потом удалить только понятные объекты:

```bash
docker container prune
docker image prune
docker builder prune
```

Volumes не трогать без отдельного решения.
