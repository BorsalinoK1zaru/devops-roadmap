1. Что делает приложение
многосервисное приложение по увеличению счетчика и сбрасыванию его

Приложение содержит 2 контейнера:
python-compose-task2 - Основная работа с endpoint
task2-redis - работа с переменной counter

2. Список endpoint-ов 

--Endpoint /
Возвращает HTML-страницу:

Название приложения
Версия
Окружение
Redis host
Redis port

--Endpoint /health
Возвращает JSON:
{
  "status": "ok"
}

--Endpoint /config
Возвращает JSON с текущей конфигурацией приложения:

{
  "app": "...",
  "version": "...",
  "environment": "...",
  "redis_host": "...",
  "redis_port": "..."
}

--Endpoint /redis-check
Проверяет подключение к Redis.
При успехе:
{
  "redis": "connected"
}

--Endpoint /counter
Увеличивает счётчик в Redis.
Первый вызов:
{
  "counter": 1
}
Следующий:
{
  "counter": 2
}

--Endpoint /reset
Сбрасывает счётчик в Redis.
После вызова /reset следующий /counter должен снова вернуть:
{
  "counter": 1
}

3. Переменные окружения

APP_NAME= Название приложения
APP_ENV= Окружение
APP_VERSION= Версия приложения
APP_PORT= Внешний порт приложения

REDIS_HOST= Имя хоста
REDIS_PORT= Порт хоста 
4. Как запустить проект

--1) перейти в папку проекта
--2) docker compose up -d

5. Как проверить endpoints через curl

curl http://localhost:8070
curl http://localhost:8070/health
curl http://localhost:8070/config
curl http://localhost:8070/redis-check
curl http://localhost:8070/counter
curl http://localhost:8070/counter
curl http://localhost:8070/reset
curl http://localhost:8070/counter
curl http://localhost:8070/counter


6. Как остановить проект

--1) перейти в папку проекта
--2) docker compose down

7. Что делает volume

Сохраняет значения из redis (В нашем случаем counter)

8. Что делает healthcheck

С его помощью мы проверяем, что сервис не только запустился, но и готов принимать команды