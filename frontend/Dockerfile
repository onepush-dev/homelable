# Homelable frontend on Railway: official ghcr.io/pouzor/homelable-frontend:3.7.1 (MIT), SPA unmodified.
# Adds: nginx listens on 8080, and proxies /api, /ws, /docs to the backend over Railway's private
# network, re-resolving the backend name through the container's DNS resolver (so backend redeploys
# with a new private IP keep working). Deleted files are overwritten instead of removed, because
# whiteouts of base-image files were not honoured at runtime.
FROM ghcr.io/pouzor/homelable-frontend:3.7.1
LABEL org.opencontainers.image.source="https://github.com/onepush-dev/homelable"
COPY 17-railway-resolver.envsh /docker-entrypoint.d/17-railway-resolver.envsh
RUN set -eu; chmod 755 /docker-entrypoint.d/17-railway-resolver.envsh; \
    t=/etc/nginx/templates/homelable.conf.template; \
    sed -i -e 's#listen 80;#listen 8080;\n    listen [::]:8080;\n    resolver ${NGINX_LOCAL_RESOLVER} valid=10s;\n    set $homelable_backend ${BACKEND_UPSTREAM};#' \
           -e 's#proxy_pass http://${BACKEND_UPSTREAM};#proxy_pass http://$homelable_backend;#' "$t"; \
    grep -q 'listen 8080' "$t"; grep -q 'proxy_pass http://$homelable_backend' "$t"; \
    printf '# Railway: intentionally empty (the Homelable server block is rendered from templates/homelable.conf.template)\n' > /etc/nginx/conf.d/default.conf; \
    printf '#!/bin/sh\n# Railway: replaced; default.conf is a placeholder here, always render homelable.conf.\n' > /docker-entrypoint.d/18-homelable-config.envsh
ENV BACKEND_UPSTREAM=backend.railway.internal:8080 \
    NGINX_ENVSUBST_FILTER='^(BACKEND_UPSTREAM|NGINX_LOCAL_RESOLVER)$'
EXPOSE 8080
