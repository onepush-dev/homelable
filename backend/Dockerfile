# Homelable backend on Railway: official ghcr.io/pouzor/homelable-backend:3.7.1 (MIT), app unmodified.
# Adds: listen on [::]:8000 (Railway private network), SQLite on the /app/data volume,
# and a generated admin password (bcrypt-hashed at boot) instead of upstream's admin/admin default.
FROM ghcr.io/pouzor/homelable-backend:3.7.1
LABEL org.opencontainers.image.source="https://github.com/onepush-dev/homelable"
COPY start.sh /opt/railway/start.sh
RUN chmod 755 /opt/railway/start.sh
ENV SQLITE_PATH=/app/data/homelab.db \
    AUTH_MODE=local \
    AUTH_USERNAME=admin \
    SCANNER_RANGES='[]'
EXPOSE 8000
CMD ["/opt/railway/start.sh"]
