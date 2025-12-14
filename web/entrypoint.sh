#!/bin/sh
set -eu

if [ "${BASIC_AUTH:-0}" = "1" ]; then
  apk add --no-cache openssl >/dev/null 2>&1 || true
  mkdir -p /etc/nginx/auth
  HASH=$(openssl passwd -apr1 "${BASIC_AUTH_PASS}")
  echo "${BASIC_AUTH_USER}:${HASH}" > /etc/nginx/auth/htpasswd

  sed -i 's|location /v1/ {|location /v1/ {\n    auth_basic "Restricted";\n    auth_basic_user_file /etc/nginx/auth/htpasswd;|g' \
    /etc/nginx/templates/default.conf.template

  sed -i 's|location /completion {|location /completion {\n    auth_basic "Restricted";\n    auth_basic_user_file /etc/nginx/auth/htpasswd;|g' \
    /etc/nginx/templates/default.conf.template
fi

exit 0
