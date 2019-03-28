#!/bin/bash

set -e

VIRTUAL_HOST="${VIRTUAL_HOST:-local.codeclou.io}"

echo ">> DOCKER-ENTRYPOINT: GENERATING SSL CERT"

cd /opt/ssl/
openssl genrsa -des3 -passout pass:x -out server.pass.key 2048
openssl rsa -passin pass:x -in server.pass.key -out server.key
rm server.pass.key
openssl req -new -key server.key -out server.csr -subj "/C=DE/ST=${VIRTUAL_HOST}/L=Nuremberg/O=${VIRTUAL_HOST}/OU=${VIRTUAL_HOST}/CN=${VIRTUAL_HOST}"
openssl x509 -req -sha256 -days 300065 -in server.csr -signkey server.key -out server.crt
cd /opt/www/

echo ">> DOCKER-ENTRYPOINT: GENERATING SSL CERT ... DONE"
echo ">> DOCKER-ENTRYPOINT: EXECUTING CMD"

exec "$@"
