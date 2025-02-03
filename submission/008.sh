# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`
TX_ID="e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163"

DETALHES_TRANSACAO=$(bitcoin-cli getrawtransaction $TX_ID 1)

#   - txinwitness[0] → Assinatura
#   - txinwitness[1] → Chave pública
#   - txinwitness[2] → Chave pública usada na assinatura
CHAVE_PUBLICA_ASSINANTE=$(echo $DETALHES_TRANSACAO | jq -r '.vin[0].txinwitness[2][4:70]')

echo $CHAVE_PUBLICA_ASSINANTE
