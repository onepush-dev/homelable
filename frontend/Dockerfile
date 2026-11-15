# Homelable frontend on Railway: official ghcr.io/pouzor/homelable-frontend:3.7.1 (MIT), SPA unmodified.
# Adds: nginx listens on 8080, and proxies /api, /ws, /docs to the backend over Railway's private
# network, re-resolving the backend name through the container's DNS resolver (so backend redeploys
# with a new private IP keep working).
FROM ghcr.io/pouzor/homelable-frontend:3.7.1
LABEL org.opencontainers.image.source="https://github.com/onepush-dev/homelable"
COPY 17-railway-resolver.envsh /docker-entrypoint.d/17-railway-resolver.envsh
RUN set -eu; chmod 755 /docker-entrypoint.d/17-railway-resolver.envsh; \
    t=/etc/nginx/templates/homelable.conf.template; \
    sed -i -e 's#listen 80;#listen 8080;\n    listen [::]:8080;\n    resolver ${NGINX_LOCAL_RESOLVER} valid=10s;\n    set $homelable_backend ${BACKEND_UPSTREAM};#' \
           -e 's#proxy_pass http://${BACKEND_UPSTREAM};#proxy_pass http://$homelable_backend;#' "$t"; \
    grep -q 'listen 8080' "$t"; grep -q 'proxy_pass http://$homelable_backend' "$t"; \
    rm -f /etc/nginx/conf.d/homelable.conf
ENV BACKEND_UPSTREAM=backend.railway.internal:8000 \
    NGINX_ENVSUBST_FILTER='^(BACKEND_UPSTREAM|NGINX_LOCAL_RESOLVER)$'
EXPOSE 8080
