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