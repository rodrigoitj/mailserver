#!/bin/bash

# Debug information
echo "Current hostname: $(hostname)"
echo "Current domainname: $(hostname -d)"
echo "Contents of /etc/hostname: $(cat /etc/hostname)"
echo "Contents of /etc/hosts: $(cat /etc/hosts)"

# Adicionar antes do start do mailserver
echo "Configurando hostname/domainname..."
echo "mail.correa.dev" > /etc/hostname
echo "correa.dev" > /etc/domainname
hostname mail.correa.dev
domainname correa.dev

# Adicionar verificação de certificados
if [ ! -f "/tmp/ssl/${DOMAINNAME:-correa.dev}/fullchain.pem" ]; then
    echo "Gerando certificados SSL de emergência..."
    mkdir -p "/tmp/ssl/${DOMAINNAME:-correa.dev}"
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout "/tmp/ssl/${DOMAINNAME:-correa.dev}/privkey.pem" \
        -out "/tmp/ssl/${DOMAINNAME:-correa.dev}/fullchain.pem" \
        -subj "/C=BR/ST=SP/L=Sao Paulo/O=Mail Server/CN=${HOSTNAME:-mail.correa.dev}"
fi

# Start the mailserver
exec /usr/local/bin/start-mailserver.sh 