#!/bin/bash

# Ruta al directorio del proyecto (ajústala si lo necesitas)
PROYECTO_DIR="/home/ubuntu/Reto3-Vacantes-1-JWT-A"
DOMAINS=("retovacantes.matabuena.com" "apireto.matabuena.com")

echo "📁 Entrando al directorio del proyecto..."
cd "$PROYECTO_DIR" || { echo "❌ No se pudo entrar al directorio"; exit 1; }

echo "📂 Verificando carpetas necesarias..."
mkdir -p ./certbot/www
mkdir -p ./certbot/dummy

echo "🔐 Generando certificados dummy para permitir el arranque de Nginx..."
for DOMAIN in "${DOMAINS[@]}"; do
  DOMAIN_PATH="./certbot/dummy/live/$DOMAIN"
  mkdir -p "$DOMAIN_PATH"
  openssl req -x509 -nodes -newkey rsa:2048 -days 1 \
    -keyout "$DOMAIN_PATH/privkey.pem" \
    -out "$DOMAIN_PATH/fullchain.pem" \
    -subj "/CN=$DOMAIN" > /dev/null 2>&1
done

echo "📦 Copiando certificados dummy a la ruta esperada por Nginx..."
for DOMAIN in "${DOMAINS[@]}"; do
  mkdir -p "./certbot/etc/live/$DOMAIN"
  cp "./certbot/dummy/live/$DOMAIN/privkey.pem" "./certbot/etc/live/$DOMAIN/privkey.pem"
  cp "./certbot/dummy/live/$DOMAIN/fullchain.pem" "./certbot/etc/live/$DOMAIN/fullchain.pem"
done

echo "🚀 Levantando servicios necesarios (nginx, backend, frontend, db)..."
docker compose up --build -d nginx frontend backend db

echo "⏳ Esperando unos segundos para que Nginx arranque..."
sleep 5

echo "🔁 Ejecutando Certbot para generar certificados SSL reales..."
docker compose run --rm certbot \
  certonly --webroot --webroot-path=/var/www/certbot \
  --email andresmatabuena15@gmail.com --agree-tos --no-eff-email \
  --force-renewal -d "${DOMAINS[0]}" -d "${DOMAINS[1]}"

echo "🔄 Reiniciando Nginx para aplicar los certificados reales..."
docker compose restart nginx

echo "✅ Despliegue completo con HTTPS configurado correctamente."
