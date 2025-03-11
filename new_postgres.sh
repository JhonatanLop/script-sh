#!/bin/bash

CONTAINER_NAME="postgres_db"

docker-compose -f /home/jhonatan/github/docker-dbs/postgre-db.yaml up -d

while ! docker ps --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; do
    echo "Aguardando o container $CONTAINER_NAME iniciar..."
    sleep 2
done

echo "Esperando Postgres estar pronto..."
while ! docker exec $CONTAINER_NAME psql -U postgres -c "SELECT 1;" &>/dev/null; do
    sleep 2
done

alacritty -e docker exec -it $CONTAINER_NAME psql -U postgres
