# Only one single output remains unspent from block 123,321. What address was it sent to?
# Obter o hash do bloco com altura 123321
BLOCO_ALTURA=123321
BLOCO_HASH=$(bitcoin-cli getblockhash $BLOCO_ALTURA)

# Listar todas as transações do bloco
TRANSACOES_NO_BLOCO=$(bitcoin-cli getblock $BLOCO_HASH | jq -r '.tx[]')

# Percorrer todas as transações do bloco
for TRANSACAO_ID in $TRANSACOES_NO_BLOCO; do
    TRANSACAO_LIMPA=$(echo "$TRANSACAO_ID" | tr -d '[:space:]') # Remover espaços e caracteres extras do TXID

    # Obter detalhes da transação e listar todas as saídas (vout)
    SAIDAS=$(bitcoin-cli getrawtransaction $TRANSACAO_LIMPA 1 | jq '.vout[]')

    # Percorrer cada saída da transação
    for INDICE_SAIDA in $(echo $SAIDAS | jq -r '.n'); do
        INDICE_SAIDA_LIMPO=$(echo "$INDICE_SAIDA" | tr -d '[:space:]')  # Remover espaços desnecessários

        # Verificar se a saída da transação ainda é válida
        VERIFICACAO=$(bitcoin-cli gettxout $TRANSACAO_LIMPA $INDICE_SAIDA_LIMPO)

        if [[ ! -z $VERIFICACAO ]]; then
            # Obter o endereço associado à saída da transação
            ENDERECO=$(echo $VERIFICACAO | jq -r '.scriptPubKey.address')
            echo "Endereço encontrado: $ENDERECO"
            exit 0
        fi
    done
done
