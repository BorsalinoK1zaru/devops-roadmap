## День 2

```bash
docker run --name devops-nginx -d -p 8080:80 nginx
docker ps #показывает запущенные контейнеры
curl http://localhost:8080 #просмотреть, что находится на главной странице контейнера (html страница)
docker logs devops-nginx #смотреть логи внутри контейнера (для поиска ошибок)
docker exec -it devops-nginx sh #возможность попасть внутрь контейнера
docker stop devops-nginx #остановка контейнера
docker rm devops-nginx #удаление контейнера