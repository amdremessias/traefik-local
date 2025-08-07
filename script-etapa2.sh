#!/bin/bash

# --- VARIAVEIS DE AMBIENTE ---
# Endereço IP do seu servidor Ubuntu
SERVER_IP=$(hostname -I | awk '{print $1}')
# Arquivo de configuração do dnsmasq
DNSMASQ_CONFIG_FILE="/etc/dnsmasq.d/00-local.conf"

echo "### INICIANDO ETAPA 2: CONFIGURAÇÃO DO DNS LOCAL ###"
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
sleep 7

if [ -z "$SERVER_IP" ]; then
    echo "ERRO: Não foi possível obter o endereço IP do servidor. Verifique a sua conexão de rede."
    exit 1
fi

# 1. Instalar dnsmasq
echo "-> Instalando dnsmasq..."
sudo apt-get install -y dnsmasq

# 2. Criar arquivo de configuração para os domínios locais
echo "-> Criando arquivo de configuração em $DNSMASQ_CONFIG_FILE"
echo "address=/local/$SERVER_IP" | sudo tee $DNSMASQ_CONFIG_FILE > /dev/null

# 3. Reiniciar o serviço dnsmasq
echo "-> Reiniciando o serviço dnsmasq..."
sudo systemctl restart dnsmasq

echo "### ETAPA 2 CONCLUÍDA ###"
echo "DNS local configurado. Os domínios *.local agora apontam para o IP do seu servidor: $SERVER_IP"
echo "Para testar, adicione 'nameserver $SERVER_IP' no topo do arquivo /etc/resolv.conf ou configure manualmente em seu cliente (Windows, macOS, etc)."

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
    \_____\___\____\... Automação Concluida | @m3ss14s-2025

______________________________________________________
"
echo ""
sleep 7
