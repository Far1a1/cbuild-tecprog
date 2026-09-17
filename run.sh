#!/bin/bash

# run.sh - comando "run" do cbuild
#
# Aqui ficam as variáveis de caminho (build/, logs/ e o executável gerado).
# A funcao log_evento monta a linha de log com data, comando, tempo, codigo
# de retorno e uma mensagem, e joga tudo num arquivo dentro de logs/.
# A cmd_run primeiro checa se o executavel existe; se nao existir ela avisa
# e sai com erro, sem tentar compilar nada. Se existir, ela roda o programa,
# mede quanto tempo levou, guarda o codigo de saida no log e devolve esse
# mesmo codigo pra quem chamou.

BUILD_DIR="build"
LOG_DIR="logs"
EXECUTAVEL="$BUILD_DIR/meu_projeto"

log_evento() {
    local comando="$1"
    local codigo="$2"
    local duracao="$3"
    local msg="$4"
    local data_hora
    data_hora=$(date '+%Y-%m-%d %H:%M:%S')
    mkdir -p "$LOG_DIR"
    echo "[$data_hora] comando=$comando codigo_retorno=$codigo duracao=${duracao}s msg=\"$msg\"" \
        >> "$LOG_DIR/cbuild_$(date +%Y%m%d).log"
}

cmd_run() {
    local args=("$@")

    if [[ ! -x "$EXECUTAVEL" ]]; then
        echo "Erro: nenhum executável encontrado em '$EXECUTAVEL'." >&2
        echo "Execute './cbuild build' antes de tentar rodar o programa." >&2
        log_evento "run" "1" "0" "executável ausente"
        return 1
    fi

    if [[ "$VERBOSE" == "true" ]]; then
        echo "[verbose] Executando: $EXECUTAVEL ${args[*]}"
    fi

    local inicio fim duracao codigo
    inicio=$(date +%s)

    "$EXECUTAVEL" "${args[@]}"
    codigo=$?

    fim=$(date +%s)
    duracao=$((fim - inicio))

    if [[ $codigo -eq 0 ]]; then
        log_evento "run" "$codigo" "$duracao" "execução concluída com sucesso"
    else
        log_evento "run" "$codigo" "$duracao" "programa retornou código $codigo"
    fi

    return $codigo
}
