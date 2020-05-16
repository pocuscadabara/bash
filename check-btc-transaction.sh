#!/bin/bash
if [ $# -eq 0 ]
then
    echo Usage: $0 [transaction hash]
fi

curl -s https://live.blockcypher.com/btc/tx/$1/|egrep "BTC|confirmations"|sed 's/<strong>//g'|sed 's/<\/strong>//g'|grep -v "^<"
