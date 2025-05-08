#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────
#  CONFIGURA TUS VARIABLES
# ─────────────────────────────────────────────
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANGULAR_DIR="$PROJECT_DIR/angular"
DIST_DIR="$ANGULAR_DIR/dist/reto3-vacantes-app"      # ⬅️  carpeta generada por ng build
DOMAIN_FRONT="retovacantes.matabuena.com"
DOMAIN_BACK="apireto.matabuena.com"
EMAIL_LETSENCRYPT="andresmatabuena15@gmail.com"

# ─────────────────────────────────────────────
# 1) COMPILAR ANGULAR Y COPIAR /dist
# ─────────────────────────────────────────────
echo "🔧 Construyendo frontend Angular…"
cd "$ANGULAR_DIR"
npm install
npm run build --configuration production

echo "📂 Build generado en $DIST_DIR"
cd "$PROJECT_DIR"

# (Opcional) verificar que el volumen existe
if [[ ! -d "$DIST_DIR" ]]; then
  echo "❌ No se encontró $DIST_DIR. Revisa el nombre de tu app en dist/."
  exit 1
fi

# ─────────────────────────────────────────────
# 2) LEVANTAR / ACTUALIZAR CONTENEDORES
# ─────────────────────────────────────────────
echo "🐳 Construyendo y levantando servicios con Docker Compose…"
docker compose up -d --build db backend apache

# ─────────────────────────────────────────────
# 3) OBTENER CERTIFICADOS (solo si no existen)
# ─────────────────────────────────────────────
if [[ ! -f "$PROJECT_DIR/certbot/etc/live/$DOMAIN_FRONT/fullchain.pem" ]]; then
  echo "🔐 Solicitando certificados SSL a Let's Encrypt (esto puede tardar)…"
  docker compose run --rm certbot certonly \
    --webroot -w /var/www/certbot \
    --email "$EMAIL_LETSENCRYPT" --agree-tos --no-eff-email \
    -d "$DOMAIN_FRONT" -d "$DOMAIN_BACK"
else
  echo "✅ Certificados ya existen; saltando emisión inicial."
fi

# ─────────────────────────────────────────────
# 4) REINICIAR APACHE PARA CARGAR CERTIFICADOS
# ─────────────────────────────────────────────
echo "♻️  Reiniciando Apache para aplicar certificados…"
docker compose restart apache

echo -e "\n🚀  Despliegue completo:"
echo "   Frontend: https://$DOMAIN_FRONT"
echo "   Backend : https://$DOMAIN_BACK (proxy a puerto 9005)"
