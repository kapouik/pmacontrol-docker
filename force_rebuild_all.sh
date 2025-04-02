#!/bin/bash
docker compose --profile pmacontrol down
docker volume rm pmacontrol-docker_config pmacontrol-docker_db pmacontrol-docker_tmpdb pmacontrol-docker_tmplog
docker rmi pmacontrol-docker-pmacontrol pmacontrol-docker-mariadb
docker builder prune -af
docker compose --profile pmacontrol up -d --build --force-recreate
