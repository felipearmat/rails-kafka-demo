#!/bin/bash

declare -a topicos=(
    "messages.publ"
    "messages.adm")

# cria um tópico
if [ $1 = create ]; then
    kafka-topics --zookeeper $KAFKA_ZOOKEEPER_CONNECT --create --replication-factor $KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR --partitions $3 --topic $2 --config "retention.ms=-1"

# deleta um tópico
elif [ $1 = delete ]; then
    kafka-topics --zookeeper $KAFKA_ZOOKEEPER_CONNECT --delete --topic $2

# imprime as informações de um tópico
elif [ $1 = desc ]; then
    kafka-topics --zookeeper $KAFKA_ZOOKEEPER_CONNECT --describe --topic $2

# lista todos os tópicos
elif [ $1 = list ]; then
    kafka-topics --zookeeper $KAFKA_ZOOKEEPER_CONNECT --list

# delete e recria um tópico
elif [ $1 = reset ]; then
    ./run.sh delete $2
    ./run.sh create $2 $3

# cria todos os tópicos
elif [ $1 = create-all ]; then
    for i in "${topicos[@]}"
    do
        ./run.sh create "$i" $KAFKA_PARTITIONS
    done

# deleta todos os tópicos
elif [ $1 = delete-all ]; then
    echo -e "Voce realmente que limpar TODOS os topicos?"
    read -p "Y/N [N]: " answer
    if [[ $answer =~ ^([yY][eE][sS]|[yY])$ ]]; then
        for i in "${topicos[@]}"
        do
            ./run.sh delete "$i"
        done
    fi

# deleta e recria todos os tópicos
elif [ $1 = reset-all ]; then
    ./run.sh delete-all
    ./run.sh create-all

# imprime todas as mensagens de um tópico
elif [ $1 = print ]; then
    kafka-console-consumer --bootstrap-server $KAFKA_SERVER --topic $2 --isolation-level read_committed --property "print.timestamp=true" --property "print.key=true" --property "print.key=true" --property key.separator=" : " --from-beginning

# retorna um produtor que recebe mensagens e as adiciona no tópico especificado
elif [ $1 = put ]; then
    kafka-console-producer --broker-list $KAFKA_SERVER --topic $2 --property "parse.key=true" --property "key.separator=:"

# Retorna o offset atual de um tópico
elif [ $1 = offset ]; then
    kafka-run-class kafka.tools.GetOffsetShell --broker-list $KAFKA_SERVER --topic $2 --time -1

# delete um grupo de consumo
elif [ $1 = gdelete ]; then
    kafka-consumer-groups --bootstrap-server $KAFKA_SERVER --group $2 --delete

# imprime as informações de um grupo de consumo
elif [ $1 = gdesc ]; then
    kafka-consumer-groups --bootstrap-server $KAFKA_SERVER --group $2 --describe

# lista todos os grupos de consumo
elif [ $1 = glist ]; then
    kafka-consumer-groups --bootstrap-server $KAFKA_SERVER --list

# volta o grupo de consumo para a PRIMEIRA mensagem de TODOS os tópicos
elif [ $1 = greset ]; then
    kafka-consumer-groups --bootstrap-server $KAFKA_SERVER --group $2 --execute --reset-offsets --all-topics --to-earliest

# passa o grupo de consumo para a ÚLTIMA mensagem de TODOS os tópicos
elif [ $1 = greset-latest ]; then
    kafka-consumer-groups --bootstrap-server $KAFKA_SERVER --group $2 --execute --reset-offsets --all-topics --to-latest

# volta o grupo de consumo para a PRIMEIRA mensagem do tópico
elif [ $1 = gresettopic ]; then
    kafka-consumer-groups --bootstrap-server $KAFKA_SERVER --group $2 --execute --reset-offsets --topic $3 --to-earliest

# passa o grupo de consumo para a ÚLTIMA mensagem do tópico
elif [ $1 = gresettopic-latest ]; then
    kafka-consumer-groups --bootstrap-server $KAFKA_SERVER --group $2 --execute --reset-offsets --topic $3 --to-latest

fi
