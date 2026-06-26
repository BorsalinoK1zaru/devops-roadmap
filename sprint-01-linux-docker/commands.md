# Commands

## День 2

```bash
docker run --name devops-nginx -d -p 8080:80 nginx

docker ps
# показывает запущенные контейнеры

curl http://localhost:8080
# просмотреть, что находится на главной странице контейнера (HTML-страница)

docker logs devops-nginx
# смотреть логи внутри контейнера для поиска ошибок

docker exec -it devops-nginx sh
# возможность попасть внутрь контейнера

docker stop devops-nginx
# остановка контейнера

docker rm devops-nginx
# удаление контейнера
```

---

## День 3

```bash
docker images
# показывает все образы Docker в среде

mkdir -p docker/nginx-site
# создаем директорию docker, внутри нее nginx-site

cd docker/nginx-site
# переходим внутрь папки nginx-site

cat > index.html <<'EOF'
<h1>Hello from my DevOps roadmap</h1>
EOF
# создаем файл index.html и записываем туда содержимое

docker run --name custom-nginx -d -p 8080:80 -v ${PWD}:/usr/share/nginx/html nginx
# создаем и запускаем контейнер custom-nginx,
# но вместо стандартной HTML-страницы Nginx подставляем свою папку по указанному пути

curl http://localhost:8080

docker stop custom-nginx

docker rm custom-nginx
```

---

## День 4

```bash
mkdir -p docker/day-04-custom-nginx

cd docker/day-04-custom-nginx

cat > index.html <<'EOF'
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>DevOps Day 4</title>
</head>
<body>
    <h1>Hello from custom Docker image</h1>
    <p>Это мой первый собственный Docker image на базе Nginx.</p>
</body>
</html>
EOF

cat > Dockerfile <<'EOF'
FROM nginx:latest

COPY index.html /usr/share/nginx/html/index.html
EOF

# FROM nginx:latest — берем за основу nginx
# COPY index.html /usr/share/nginx/html/index.html — вставляем свою главную страницу вместо той, которую ожидает Nginx

docker build -t my-nginx-site:day4 .
# собираем образ

docker images
# выводим все образы

docker run --name my-nginx-container -d -p 8080:80 my-nginx-site:day4
# создаем и запускаем контейнер из образа my-nginx-site:day4

docker ps

curl http://localhost:8080

docker exec -it my-nginx-container sh

docker stop my-nginx-container

docker rm my-nginx-container
```

---

## День 5

```bash
mkdir -p docker/day-05-layers-cache

cd docker/day-05-layers-cache

cat > index.html <<'EOF'
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>DevOps Day 5</title>
</head>
<body>
    <h1>Docker Layers and Cache</h1>
    <p>Это главная страница.</p>
</body>
</html>
EOF

cat > about.html <<'EOF'
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>About Docker Cache</title>
</head>
<body>
    <h1>About page</h1>
    <p>Эта страница нужна для проверки нескольких COPY-инструкций.</p>
</body>
</html>
EOF

cat > Dockerfile <<'EOF'
FROM nginx:latest

LABEL project="devops-roadmap"
LABEL lesson="day-05-layers-cache"

RUN mkdir -p /usr/share/nginx/html/pages

COPY index.html /usr/share/nginx/html/index.html
COPY about.html /usr/share/nginx/html/pages/about.html
EOF

docker build -t my-nginx-site:day5 .

docker build -t my-nginx-site:day5 .
# повторная сборка для проверки Docker cache

docker run --name day5-nginx -d -p 8080:80 my-nginx-site:day5

curl http://localhost:8080

curl http://localhost:8080/pages/about.html

# изменение index.html

cat > index.html <<'EOF'
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>DevOps Day 5 Updated</title>
</head>
<body>
    <h1>Docker Cache Updated</h1>
    <p>Я изменил index.html и пересобрал image.</p>
</body>
</html>
EOF

docker build -t my-nginx-site:day5 .

docker stop day5-nginx

docker rm day5-nginx

docker run --name day5-nginx -d -p 8080:80 my-nginx-site:day5

curl http://localhost:8080

docker history my-nginx-site:day5

docker stop day5-nginx

docker rm day5-nginx
```

---

## День 6

```bash
mkdir -p docker/day-06-python-app

cd docker/day-06-python-app

cat > app.py <<'EOF'
from flask import Flask, jsonify

app = Flask(__name__)


@app.get("/")
def index():
    return """
    <h1>Hello from Python Docker container</h1>
    <p>Это мое первое Python web-приложение внутри Docker.</p>
    """


@app.get("/health")
def health():
    return jsonify({
        "status": "ok",
        "service": "day-06-python-app"
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
EOF

cat > requirements.txt <<'EOF'
Flask
gunicorn
EOF

cat > Dockerfile <<'EOF'
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
EOF

docker build -t python-web-app:day6 .

docker images

docker run --name day6-python-app -d -p 5000:5000 python-web-app:day6

docker ps

curl http://localhost:5000

curl http://localhost:5000/health

docker logs day6-python-app

docker exec -it day6-python-app sh

docker stop day6-python-app

docker rm day6-python-app
```

## День 7

```bash
cd docker/day-06-python-app

# обновил app.py: добавил os.getenv(), /version и переменные APP_NAME, APP_VERSION, APP_ENV

docker build -t python-web-app:day7 .

docker run --name day7-python-app -d -p 5000:5000 python-web-app:day7

curl http://localhost:5000
curl http://localhost:5000/version

docker stop day7-python-app
docker rm day7-python-app

docker run --name day7-python-app \
  -d \
  -p 5050:5000 \
  -e APP_NAME="DevOps Roadmap App" \
  -e APP_VERSION="1.0.0" \
  -e APP_ENV="development" \
  python-web-app:day7

curl http://localhost:5050
curl http://localhost:5050/health
curl http://localhost:5050/version

docker exec -it day7-python-app sh

docker logs day7-python-app

docker stop day7-python-app
docker rm day7-python-app
```

## День 8

```bash
mkdir -p docker/day-08-docker-network
cd docker/day-08-docker-network

# создал app.py, requirements.txt и Dockerfile

docker network create devops-net
docker network ls
docker network inspect devops-net

docker run --name day8-redis -d --network devops-net redis:7-alpine

docker ps
docker logs day8-redis

docker build -t python-network-app:day8 .

docker run --name day8-python-app \
  -d \
  --network devops-net \
  -p 7070:5000 \
  -e APP_NAME="Docker Network Practice" \
  -e REDIS_HOST="day8-redis" \
  -e REDIS_PORT="6379" \
  python-network-app:day8

curl http://localhost:7070
curl http://localhost:7070/health
curl http://localhost:7070/redis-check
curl http://localhost:7070/counter
curl http://localhost:7070/counter
curl http://localhost:7070/counter

docker network inspect devops-net

docker exec -it day8-python-app sh

docker stop day8-python-app day8-redis
docker rm day8-python-app day8-redis
```

## День 9

```bash
cd docker/day-08-docker-network

docker rm -f day8-python-app day8-redis

docker volume create redis-data
docker volume ls
docker volume inspect redis-data

docker network ls
docker network create devops-net

docker run --name day9-redis \
  -d \
  --network devops-net \
  -v redis-data:/data \
  redis:7-alpine

docker build -t python-network-app:day9 .

docker run --name day9-python-app \
  -d \
  --network devops-net \
  -p 7070:5000 \
  -e APP_NAME="Docker Volume Practice" \
  -e REDIS_HOST="day9-redis" \
  -e REDIS_PORT="6379" \
  python-network-app:day9

curl http://localhost:7070/redis-check
curl http://localhost:7070/counter
curl http://localhost:7070/counter
curl http://localhost:7070/counter

docker exec -it day9-redis redis-cli SAVE

docker stop day9-redis
docker rm day9-redis

docker run --name day9-redis \
  -d \
  --network devops-net \
  -v redis-data:/data \
  redis:7-alpine

curl http://localhost:7070/counter

docker exec -it day9-redis sh

docker stop day9-python-app day9-redis
docker rm day9-python-app day9-redis
```

## День 10

```bash
mkdir -p docker/day-10-docker-compose
cd docker/day-10-docker-compose

# создал app.py, requirements.txt, Dockerfile и compose.yaml

docker compose up -d

docker compose ps

curl http://localhost:8080
curl http://localhost:8080/health
curl http://localhost:8080/redis-check
curl http://localhost:8080/counter
curl http://localhost:8080/counter
curl http://localhost:8080/counter

docker compose logs
docker compose logs app
docker compose logs redis

docker network ls
docker volume ls

docker compose exec app sh

docker compose down

docker ps
docker volume ls
```

## День 11

```bash
mkdir -p docker/day-11-compose-env-healthcheck
cd docker/day-11-compose-env-healthcheck

# создал app.py, requirements.txt, Dockerfile, .env и compose.yaml

docker compose up -d

docker compose ps

curl http://localhost:8090
curl http://localhost:8090/health
curl http://localhost:8090/config
curl http://localhost:8090/redis-check
curl http://localhost:8090/counter
curl http://localhost:8090/counter

docker compose exec app sh

docker inspect day11-redis --format='{{json .State.Health}}'

docker compose logs app
docker compose logs redis

docker compose down
```