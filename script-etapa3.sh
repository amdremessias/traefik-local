#!/bin/bash

# --- VARIAVEIS DE AMBIENTE ---
# Diretório para o Traefik
TRAEFIK_DIR="/opt/traefik"
CERT_DIR="/etc/ssl/local"

echo "### INICIANDO ETAPA 3: DEPLOY DO TRAEFIK ###"
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
echo ""
sleep 7
# 1. Criar diretório para o Traefik
echo "-> Criando diretório para o Traefik em $TRAEFIK_DIR"
sudo mkdir -p $TRAEFIK_DIR
sudo chown -R $USER:$USER $TRAEFIK_DIR

# 2. Criar arquivo docker-compose.yml
echo "-> Criando arquivo docker-compose.yml..."
cat <<EOF > $TRAEFIK_DIR/docker-compose.yml
version: '3.8'

services:
  traefik:
    image: traefik:v2.11
    container_name: traefik
    restart: always
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - $CERT_DIR:/etc/certs
    command:
      - --api.insecure=true
      - --providers.docker=true
      - --providers.docker.exposedbydefault=false
      - --entrypoints.web.address=:80
      - --entrypoints.websecure.address=:443
      - --entrypoints.web.http.redirections.entrypoint.to=websecure
      - --entrypoints.web.http.redirections.entrypoint.scheme=https
      - --entrypoints.websecure.http.tls.certresolver=localca
      - --providers.file.directory=/etc/traefik/dynamic
      - --log.level=INFO
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.api.rule=Host(\`traefik.local\`)"
      - "traefik.http.routers.api.service=api@internal"
      - "traefik.http.routers.api.middlewares=auth@file"

  # Exemplo de serviço (Chatwoot) - adicionar a ele as labels
  #chatwoot:
  #  image: chatwoot/chatwoot:latest
  #  labels:
  #    - "traefik.enable=true"
  #    - "traefik.http.routers.chatwoot.rule=Host(\`chatwoot.local\`)"
  #    - "traefik.http.routers.chatwoot.entrypoints=websecure"
  #    - "traefik.http.routers.chatwoot.tls=true"
  #    - "traefik.http.services.chatwoot.loadbalancer.server.port=3000"

  # Exemplo de serviço (Evolution API) - adicionar a ele as labels
  #evolution-api:
  #  image: evolutionapi/evolution-api:latest
  #  labels:
  #    - "traefik.enable=true"
  #    - "traefik.http.routers.evolution.rule=Host(\`api.evolution.local\`)"
  #    - "traefik.http.routers.evolution.entrypoints=websecure"
  #    - "traefik.http.routers.evolution.tls=true"
  #    - "traefik.http.services.evolution.loadbalancer.server.port=8080"
EOF

# 3. Iniciar o Traefik
echo "-> Iniciando o Traefik com Docker Compose..."
docker compose -f $TRAEFIK_DIR/docker-compose.yml up -d

echo "### ETAPA 3 CONCLUÍDA ###"
echo "O Traefik foi iniciado. Agora você pode adicionar os seus serviços (Chatwoot, Evolution API) no Docker Compose e adicionar as labels do Traefik para que ele os exponha."
