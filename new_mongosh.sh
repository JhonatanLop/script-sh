#!/bin/bash

CONTAINER_NAME="mongodb_sh"

docker-compose -f /home/jhonatan/github/docker-dbs/mongo-db.yaml up -d

while ! docker ps --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; do
    echo "Aguardando o container $CONTAINER_NAME iniciar..."
    sleep 2
done

echo "Esperando MongoDB estar pronto..."
while ! docker exec $CONTAINER_NAME mongosh --eval "db.runCommand({ ping: 1 })" &>/dev/null; do
    sleep 2
done

alacritty -e docker exec -it $CONTAINER_NAME mongosh -u admin -p password
