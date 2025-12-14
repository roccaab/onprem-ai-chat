#!/usr/bin/env bash
set -euo pipefail

LLAMA_HOST="${LLAMA_HOST:-0.0.0.0}"
# Render espone la porta in $PORT per web services; per private può essere vuoto, quindi fallback
LLAMA_PORT="${PORT:-${LLAMA_PORT:-8080}}"
CTX="${CTX:-2048}"
THREADS="${THREADS:-4}"

MODEL_DIR="${MODEL_DIR:-/var/models}"
MODEL_FILE="${MODEL_FILE:-smollm3.gguf}"
MODEL_PATH="${MODEL_DIR%/}/${MODEL_FILE}"

# MODEL_URL può contenere CRLF o spazi invisibili da copy/paste (tipico da Windows/console).
MODEL_URL_RAW="${MODEL_URL:-}"
MODEL_URL_CLEAN="$(printf '%s' "${MODEL_URL_RAW}" | tr -d '\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

mkdir -p "${MODEL_DIR}"

if [ ! -f "${MODEL_PATH}" ]; then
  if [ -z "${MODEL_URL_CLEAN}" ]; then
    echo "ERRORE: modello non trovato (${MODEL_PATH}) e MODEL_URL non impostato."
    exit 1
  fi

  echo "Modello non presente. Download da: ${MODEL_URL_CLEAN}"
  # -L segue redirect (HuggingFace), --fail fallisce su HTTP != 2xx
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
