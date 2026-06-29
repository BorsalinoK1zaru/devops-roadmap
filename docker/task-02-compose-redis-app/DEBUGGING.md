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
