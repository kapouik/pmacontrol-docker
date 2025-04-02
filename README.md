# pmacontrol-docker
Docker image for pmacontrol

To run it :
```
docker compose --profile pmacontrol up -d
```

To stop it :
```
docker compose --profile pmacontrol down
```

To upgrade it :
```
docker compose --profile pmacontrol down
docker volume rm pmacontrol-docker_config pmacontrol-docker_db pmacontrol-docker_tmpdb pmacontrol-docker_tmplog
docker rmi pmacontrol-docker-pmacontrol
docker builder prune -af
docker compose --profile pmacontrol up -d --build --force-recreate
```
