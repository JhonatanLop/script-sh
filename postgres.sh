#!/bin/bash

open_postgre() {
    sleep 0.5
    docker exec -it $1 psql -U postgres
}

start_postgre() {
    sleep 0.5
    docker-compose -f /home/jhonatan/github/docker-dbs/postgre-db.yaml up -d
    echo "Aguardando a inicialização do conteiner..."
    sleep 1
    while ! docker ps --format '{{.Names}}' | grep "postgres_db"; do
        sleep 2
    done
    docker exec -it postgres_db psql -U postgres
}

running_containers=$(docker ps --filter "ancestor=postgres" --format "{{.Names}}")

if [[ -z "$running_containers" ]]; then
    echo "Nenhum contêiner Postgres em execução"
    sleep 0.2
    echo "Inicializando contêiner padrão..."
    start_postgre
    exit 1
fi

if [[ $(echo "$running_containers" | wc -l) -eq 1 ]]; then
    CONTAINER_NAME=$running_containers
    echo -e "Contêiner Postgres em execução: \e[36m$CONTAINER_NAME\e[0m"
    echo -e "Abrindo o psql... \e[32m(CTRL + D para sair)\e[0m"
    sleep 0.5
else
    # Pergunta ao usuário qual contêiner selecionar
    echo "Contêineres Postgres em execução:"
    select CONTAINER_NAME in $running_containers; do
        if [[ -n "$CONTAINER_NAME" ]]; then
            break
        else
            echo "Seleção inválida."
        fi
    done
fi

open_postgre $CONTAINER_NAME
