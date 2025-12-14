#!/usr/bin/env bash
set -euo pipefail

LLAMA_HOST="${LLAMA_HOST:-0.0.0.0}"
# Private service: usa LLAMA_PORT (non $PORT) per restare coerente col proxy
LLAMA_PORT="${LLAMA_PORT:-8080}"

CTX="${CTX:-2048}"
THREADS="${THREADS:-4}"

MODEL_DIR="${MODEL_DIR:-/var/models}"
MODEL_FILE="${MODEL_FILE:-smollm3.gguf}"
MODEL_PATH="${MODEL_DIR%/}/${MODEL_FILE}"

# Pulisce CRLF e spazi invisibili da copy/paste (tipico Windows)
MODEL_URL_RAW="${MODEL_URL:-}"
MODEL_URL_CLEAN="$(printf '%s' "${MODEL_URL_RAW}" | tr -d '\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

mkdir -p "${MODEL_DIR}"
mkdir -p "$(dirname "${MODEL_PATH}")"

if [ ! -f "${MODEL_PATH}" ]; then
  if [ -z "${MODEL_URL_CLEAN}" ]; then
    echo "ERRORE: modello non trovato (${MODEL_PATH}) e MODEL_URL non impostato."
    exit 1
  fi
  echo "Modello non presente. Download da: ${MODEL_URL_CLEAN}"
  curl -L --fail "${MODEL_URL_CLEAN}" -o "${MODEL_PATH}"
  echo "Download completato: ${MODEL_PATH}"
else
  echo "Modello già presente: ${MODEL_PATH}"
fi

echo "Avvio llama-server..."
echo "HOST=${LLAMA_HOST} PORT=${LLAMA_PORT} CTX=${CTX} THREADS=${THREADS}"
exec /usr/local/bin/llama-server \
  -m "${MODEL_PATH}" \
  -c "${CTX}" \
  -t "${THREADS}" \
  --host "${LLAMA_HOST}" \
  --port "${LLAMA_PORT}"

