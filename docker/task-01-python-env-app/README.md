1. Приложение возвращает JSON файлы в зависимости от запросов. Главная суть - первое тестовое задание

2. endpoint:
"/version" возвращает:
    "app": APP_NAME,
    "version": APP_VERSION,
    "environment": APP_ENV
"/health" возвращает:
    "status": "ok"
"/info" возввращает:
    "app": APP_NAME,
    "version": APP_VERSION,
    "environment": APP_ENV,
    "author": MAINTAINER

3. переменные окружение имеются следующие:

APP_NAME - Имя приложения
APP_VERSION - Версия приложения
APP_ENV - Окружение
MAINTAINER - Разработчик

4. Сборка image осуществляется командой:
    docker build -t python-env-app:task1 .


5. Запуск контейнера с переменными окружения

docker run --name task1-python-env-app \
  -d \
  -p 6060:5000 \
  -e APP_NAME="Мое первое тестовое приложение" \
  -e APP_VERSION="1.0.1" \
  -e APP_ENV="development" \
  -e MAINTAINER="b6erezzzovsk1y" \
  python-env-app:task1

    Запуск контейнера без переменных окружения
docker run --name task1-python-env-app -d -p 6060:5000 python-env-app:task1

6. Проверка endpoint'ов:

curl http://localhost:6060
curl http://localhost:6060/health
curl http://localhost:6060/version
curl http://localhost:6060/info