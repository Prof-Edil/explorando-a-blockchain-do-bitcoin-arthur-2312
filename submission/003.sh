# How many new outputs were created by block 123,456?
hsh=$(bitcoin-cli getblockhash 123456)
outputs=$(bitcoin-cli getblock $hsh 1 | jq "[.tx[].vout | length] | add")
echo $outputs
