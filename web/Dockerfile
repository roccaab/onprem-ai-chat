FROM nginx:alpine
COPY nginx.conf.template /etc/nginx/templates/default.conf.template
COPY entrypoint.sh /docker-entrypoint.d/99-entrypoint.sh
RUN chmod +x /docker-entrypoint.d/99-entrypoint.sh
COPY html /usr/share/nginx/html
