# Which tx in block 257,343 spends the coinbase output of block 256,128?
# Obter o hash do bloco 256128 e sua transação coinbase (geralmente a primeira do bloco)
BLOCO_ANTERIOR_ALTURA=256128
BLOCO_ANTERIOR_HASH=$(bitcoin-cli getblockhash $BLOCO_ANTERIOR_ALTURA)
TRANSACAO_COINBASE=$(bitcoin-cli getblock $BLOCO_ANTERIOR_HASH | jq -r '.tx[0]')

BLOCO_ATUAL_ALTURA=257343
BLOCO_ATUAL_HASH=$(bitcoin-cli getblockhash $BLOCO_ATUAL_ALTURA)
TRANSACOES_NO_BLOCO=$(bitcoin-cli getblock $BLOCO_ATUAL_HASH | jq -r '.tx[]')

for TRANSACAO_ID in $TRANSACOES_NO_BLOCO; do
    
    TRANSACAO_LIMPA=$(echo "$TRANSACAO_ID" | tr -d '[:space:]') 
    ENTRADAS=$(bitcoin-cli getrawtransaction "$TRANSACAO_LIMPA" 1 | jq -r '.vin[].txid')

    for ENTRADA in $ENTRADAS; do
        ENTRADA_LIMPA=$(echo "$ENTRADA" | tr -d '[:space:]') 
        if [[ "$ENTRADA_LIMPA" == "$TRANSACAO_COINBASE" ]]; then
            echo $TRANSACAO_LIMPA
            exit 0
        fi
    done
done
