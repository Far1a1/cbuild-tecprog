#!/bin/bash

#CAMINHO DO ARQUIVO DE CONFIGURAÇÕES
CONFIG_PATH="${HOME}/.config/cbuild"

#CAMINHO DE LOG
LOG_PATH="${HOME}/.cache/cbuild/log"

#Tenta ler as configurações padrões e caso não haja gera o arquivo
if ! test -f $CONFIG_PATH ; then 
    echo $CONFIG_PATH
    yes | cp "./templateConfig" $CONFIG_PATH
fi

if ! test -f $LOG_PATH ; then 
    mkdir -p $(dirname $LOG_PATH)
    touch $LOG_PATH
fi

. $CONFIG_PATH


command="$(date): $0 "
for i ; do
    command+="$i ";
done
echo $command >> $LOG_PATH

if [ $# -lt 1 ] ; then
    #throw exception
fi

case $1 in
    "run")
    ;;
    "build")
        #chamar script
    ;;
    "rebuild")
    ;;
    "clean")
    ;;
    "info")
    ;;
    *)
        #pegar excessao
    ;;
esac


