#!/bin/bash

# Script para hacer PRIVADOS todos los repositorios públicos
# FHuntet05 - Script de GitHub API

GITHUB_TOKEN="${1:-}"
USERNAME="FHuntet05"

if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ ERROR: Debes proporcionar tu token de GitHub"
    echo "Uso: bash make_private.sh TU_TOKEN_AQUI"
    echo ""
    echo "Para obtener un token:"
    echo "1. Ve a: https://github.com/settings/tokens"
    echo "2. Click en 'Generate new token (classic)'"
    echo "3. Marca estos permisos: 'repo' (todos los checkboxes)"
    echo "4. Copia el token y úsalo en este script"
    exit 1
fi

# Lista de todos tus repositorios públicos
REPOS=(
  "AI-Trader-PYTHON"
  "artillery"
  "atu-admin-bot"
  "atu-mining-backend"
  "atu-mining-frontend"
  "block_backend"
  "block_frontend"
  "clon-backend"
  "clon-frontend"
  "CL_bot-"
  "crustercustfeft05"
  "encoder-bot"
  "EsteFile-Sharing-Bot"
  "fabrica-backend"
  "Huuu"
  "m1_p4qu373"
  "matomo"
  "mirror-leech-telegram-bot"
  "PYRO-RENAME-BOT"
  "python-bot"
  "reenviarscript"
  "Rename-Bot-V1.0"
  "RenamerS"
  "Save-Restricted-Content-Bot-v3"
  "SaveRestrictedContentBotMY"
  "system-prompts-and-models-of-ai-tools"
  "telegrampackbot"
  "TG-FileStore"
  "tg-index"
  "TGMessageStore"
  "trade_backend"
  "trade_frontend"
  "Video-Encoder-Bot"
  "hash-backend"
  "hash_frontend"
  "TG-FileStore"
  "hash_frontend"
)

echo "🔒 Iniciando conversión a PRIVADO..."
echo "📊 Total de repos a procesar: ${#REPOS[@]}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

EXITOSOS=0
FALLIDOS=0
FAILED_REPOS=()

for repo in "${REPOS[@]}"; do
  echo -n "🔄 Procesando: $repo ... "
  
  RESPONSE=$(curl -s -X PATCH \
    -H "Authorization: token $GITHUB_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    https://api.github.com/repos/$USERNAME/$repo \
    -d '{"private":true}' \
    -w "\n%{http_code}")
  
  HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
  
  if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ PRIVADO"
    ((EXITOSOS++))
  else
    echo "❌ ERROR (HTTP $HTTP_CODE)"
    ((FALLIDOS++))
    FAILED_REPOS+=("$repo")
  fi
  
  # Pequeña pausa para no saturar la API
  sleep 1
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 RESUMEN:"
echo "✅ Exitosos: $EXITOSOS"
echo "❌ Fallidos: $FALLIDOS"

if [ $FALLIDOS -gt 0 ]; then
    echo ""
    echo "Repos que fallaron:"
    for failed_repo in "${FAILED_REPOS[@]}"; do
        echo "  ❌ $failed_repo"
    done
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ ¡Proceso completado!"
