#!/bin/bash

echo "
   _____
  | ___ |
  ||   ||  T.I.
  ||___||
  |   _ |
  |_____|
 /_/_|_\_\----.
/_/__|__\_\   )
             (
             []


"
# --- VARIAVEIS DE AMBIENTE ---
# Nomes dos domínios para os quais os certificados serão gerados
DOMAINS="chatwoot.local api.evolution.local"

# Diretório para armazenar os certificados
CERT_DIR="/etc/ssl/local"

echo "### INICIANDO ETAPA 1: CONFIGURAÇÃO DE CERTIFICADOS ###"

# 1. Instalar mkcert e dependências
echo "-> Instalando dependências e mkcert..."
sudo apt-get update
sudo apt-get install -y curl
curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux&arch=amd64"
chmod +x mkcert-v*-linux-amd64
sudo mv mkcert-v*-linux-amd64 /usr/local/bin/mkcert

# 2. Gerar Autoridade Certificadora (AC) local
echo "-> Gerando Autoridade Certificadora (AC) local..."
mkcert -install

# 3. Criar diretório para certificados
echo "-> Criando diretório para certificados: $CERT_DIR"
sudo mkdir -p $CERT_DIR
sudo chown -R $USER:$USER $CERT_DIR

# 4. Gerar certificados para os domínios
echo "-> Gerando certificados para os domínios: $DOMAINS"
mkcert -key-file $CERT_DIR/local.key -cert-file $CERT_DIR/local.pem $DOMAINS

echo "### ETAPA 1 CONCLUÍDA ###"
echo "Certificados gerados em: $CERT_DIR"
echo "Lembre-se de instalar o certificado da CA (gerado por mkcert -install) nos seus navegadores para que os certificados sejam confiáveis."
echo "
 ______________
||            ||
||            ||
||            ||
||            ||
||____________||
|______________|
 \\##############\\
  \\##############\\
   \      ____    \   
    \_____\___\____\... fim da primeira etapa | @m3ss14s-2025

______________________________________________________
"
