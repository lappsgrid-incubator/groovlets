#!/usr/bin/env bash

file="src/test/resources/karen.lif"

if (ps aux | grep server.groovy | grep java) ; then
	echo "Groovy server is already running"
else
	echo "Please start the server.groovy script first."
	exit 1
fi

type="Content-type: application/json"
url="LAPPS-PROXY-URL: http://vassar.lappsgrid.org/invoker/anc:stanford.tokenizer_2.0.0"
username="LAPPS-PROXY-USERNAME: weblicht" 
password="LAPPS-PROXY-PASSWORD: weblicht"

if [ -z "$1" ] ; then
    curl -i -X POST -H "$type" -H "$url" -d @src/test/resources/karen.lif http://localhost:8888/soap-proxy
    exit 0
fi

case $1 in
    headers)
        curl -i -X POST -H "$type" -H "$url" -H "$username" -H "$password" --data-binary @src/test/resources/karen.lif http://localhost:8888/soap-proxy
        ;;
    url)
        curl -i -X POST -H "$type" -H "$url" -d @src/test/resources/karen.lif http://localhost:8888/soap-proxy
        ;;
    params)
        curl -i -X POST -H "$type" -d @src/test/resources/karen-parameters.lif http://localhost:8888/soap-proxy
        ;;
    baduser)
        curl -i -X POST -H "$type" -H "$url" -H "LAPPS-PROXY-USERNAME: unknown" -H "$password" --data-binary @src/test/resources/karen.lif http://localhost:8888/soap-proxy
        ;;
    badpass)
        curl -i -X POST -H "$type" -H "$url" -H "$username" -H "LAPPS-PROXY-PASSWORD: n0s3cr37" --data-binary @src/test/resources/karen.lif http://localhost:8888/soap-proxy
        ;;
    *)
        echo "Invalid option: one of headers, url, params, baduser, badpass"
        exit 1
        ;;
esac