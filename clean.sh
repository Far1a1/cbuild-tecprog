#!/bin/bash
#
#clean.sh - comando "clean" do cbuild
#
#remove artefatos de compilação(diretório build/ e executável) e pega as logs
#
#Uso:
#    ./clean.sh[--dir <caminho>][-v|--verbose]
#Códigos de retorno:
#   0-Sucesso(havia algo pra limpar ou não, sem erro)
#   1-Diretório do projeto inexistente
#   2-Falha de permissão ao remover arquivos
#




VERBOSE=0
verbose_true(){
    if [[ "$VERBOSE" -eq 1 ]]; then
        echo "[clean] $1"
    fi
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dir)
            Diret=$2
            shift 2

            ;;
        -v|--verbose)
            VERBOSE=1
            shift 1
            ;;
        *)
            echo "Erro: opção inválida '$1'">&2
            exit 1
            ;;
            
    esac
done



 registrar_log(){
codigo=$1
resultado=$2
erro=${3:-nenhum}

{
    echo "data=$(date +"%Y-%m-%d %H:%M:%S")"    
    echo "comando=clean"
    echo "duração=${SECONDS}s"
    echo "codigo_retorno=${codigo}"
    echo "resultado=${resultado}"
    echo "erro=${erro}"
}>>"$LOG_PATH"
 }

Diret="${Diret:-.}"

if [[ ! -d "$Diret" ]]; then
    echo "Erro: diretório do projeto '$Diret' não existe." >&2
    resultado="diretorio_inexistente"
    registrar_log 1 "$resultado"
    exit 1
fi


if [[ -d "$Diret/build" ]]; then
    verbose_true "Removendo conteúdo de '$Diret/build'..."
    if rm -rf "$Diret/build/"; then
     resultado="build_limpo"
     registrar_log 0 $resultado
     verbose_true "Artefatos de compilação removidos"
     exit 0 #rm deu certo(código 0)
    else 
     echo "isso é um erro" >&2
     resultado="permissao_negada"
     registrar_log 2 $resultado
     exit 2
    fi
else 
echo "nada para limpar"
resultado="nada_a_limpar"
verbose_true "Nada para limpar, '$Diret/build' não existe ou já está vazio"
registrar_log 0 $resultado
exit 0
fi


