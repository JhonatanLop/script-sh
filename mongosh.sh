#!/bin/bash

open_mongosh() {
    sleep 0.5
    docker exec -it $1 mongosh -u admin -p password
}

start_mongodb() {
    sleep 0.5
    docker-compose -f /home/jhonatan/github/docker-dbs/mongo-db.yaml up -d
    echo "Aguardando a inicialização do conteiner..."
    sleep 1
    while ! docker ps --format '{{.Names}}' | grep "mongodb_sh"; do
        sleep 2
    done
    docker exec -it mongodb_sh mongosh -u admin -p password
}

running_containers=$(docker ps --filter "ancestor=mongo" --format "{{.Names}}")

if [[ -z "$running_containers" ]]; then
    echo "Nenhum contêiner Mongo em execução"
    sleep 0.2
    echo "Inicializando contêiner padrão..."
    start_mongodb
    exit 1
fi

if [[ $(echo "$running_containers" | wc -l) -eq 1 ]]; then
    CONTAINER_NAME=$running_containers
else
    # Pergunta ao usuário qual contêiner selecionar
    echo "Contêineres Mongo em execução:"
    select CONTAINER_NAME in $running_containers; do
        if [[ -n "$CONTAINER_NAME" ]]; then
            break
        else
            echo "Seleção inválida."
        fi
    done
fi

open_mongosh $CONTAINER_NAME
