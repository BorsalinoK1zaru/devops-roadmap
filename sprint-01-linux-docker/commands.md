## День 2

```bash
docker run --name devops-nginx -d -p 8080:80 nginx
docker ps #показывает запущенные контейнеры
curl http://localhost:8080 #просмотреть, что находится на главной странице контейнера (html страница)
docker logs devops-nginx #смотреть логи внутри контейнера (для поиска ошибок)
docker exec -it devops-nginx sh #возможность попасть внутрь контейнера
docker stop devops-nginx #остановка контейнера
docker rm devops-nginx #удаление контейнера
```

## День 3

```bash
docker images #показывает все образы докера в среде
mkdir -p docker/nginx-site #создаем директорию docker внутри нее nginx-site
cd docker/nginx-site #переходим внутрь папки nginx-site
echo '<h1>Hello from my DevOps roadmap</h1>' > index.html #создаем файл index.html  и записываем туда содержимое "<h1>..."
docker run --name custom-nginx -d -p 8080:80 -v ${PWD}:/usr/share/nginx/html nginx # создаем и запускаем контейнер custom-nginx, но вместо корневого html файла подставляем свой по указанному пути
curl http://localhost:8080
docker stop custom-nginx
docker rm custom-nginx
```


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

#FROM nginx:latest берем за основу nginx

#COPY index.html /usr/share/nginx/html/index.html вставляем свою главную страницу заместо той, которую ждет nginx

docker build -t my-nginx-site:day4 . #собираем образ
docker images # выводим все образы
docker run --name my-nginx-container -d -p 8080:80 my-nginx-site:day4 #собираем и запускаем контейнер по образу my-nginx-site:day4
docker ps
curl http://localhost:8080
docker exec -it my-nginx-container sh
docker stop my-nginx-container
docker rm my-nginx-container
```

## День 5

```bash
mkdir -p docker/day-05-layers-cache
cd docker/day-05-layers-cache

cat > index.html <<'EOF'
...
EOF

cat > about.html <<'EOF'
...
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
docker run --name day5-nginx -d -p 8080:80 my-nginx-site:day5
curl http://localhost:8080
curl http://localhost:8080/pages/about.html

# изменение index.html
docker build -t my-nginx-site:day5 .
docker stop day5-nginx
docker rm day5-nginx
docker run --name day5-nginx -d -p 8080:80 my-nginx-site:day5
curl http://localhost:8080
docker history my-nginx-site:day5
docker stop day5-nginx
docker rm day5-nginx
```