docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker volume rm $(docker volume ls -q)
docker compose --profile pmacontrol down
docker rmi $(docker images -q)
docker builder prune -af
docker compose --profile pmacontrol up -d --build --force-recreate
