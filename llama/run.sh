#!/usr/bin/env bash
set -euo pipefail

LLAMA_HOST="${LLAMA_HOST:-0.0.0.0}"
LLAMA_PORT="${PORT:-8080}"          # Render espone la porta in $PORT per web services; per private può essere vuoto, quindi fallback
CTX="${CTX:-2048}"
THREADS="${THREADS:-4}"

MODEL_DIR="${MODEL_DIR:-/var/models}"
MODEL_FILE="${MODEL_FILE:-smollm3.gguf}"
MODEL_PATH="${MODEL_DIR%/}/${MODEL_FILE}"

# Se definito, scarica modello se non esiste
MODEL_URL="${MODEL_URL:-}"

mkdir -p "${MODEL_DIR}"

if [ ! -f "${MODEL_PATH}" ]; then
  if [ -z "${MODEL_URL}" ]; then
    echo "ERRORE: modello non trovato (${MODEL_PATH}) e MODEL_URL non impostato."
    exit 1
  fi
  echo "Modello non presente. Download da: ${MODEL_URL}"
  curl -L --fail "${MODEL_URL}" -o "${MODEL_PATH}"
  echo "Download completato: ${MODEL_PATH}"
fi

echo "Avvio llama-server..."
exec /usr/local/bin/llama-server \
  -m "${MODEL_PATH}" \
  -c "${CTX}" \
  -t "${THREADS}" \
  --host "${LLAMA_HOST}" \
  --port "${LLAMA_PORT}"
