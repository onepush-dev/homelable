#!/bin/sh
set -e
mkdir -p /app/data
if [ -n "${HOMELABLE_ADMIN_PASSWORD:-}" ]; then
  AUTH_PASSWORD_HASH=$(python -c 'import bcrypt,os; print(bcrypt.hashpw(os.environ["HOMELABLE_ADMIN_PASSWORD"].encode(), bcrypt.gensalt()).decode())')
  export AUTH_PASSWORD_HASH
  echo "railway: admin password set from HOMELABLE_ADMIN_PASSWORD (user: ${AUTH_USERNAME:-admin})"
elif [ -z "${AUTH_PASSWORD_HASH:-}" ]; then
  echo "railway: set HOMELABLE_ADMIN_PASSWORD (or AUTH_PASSWORD_HASH); refusing to start with upstream's default admin/admin" >&2
  exit 1
fi
exec uvicorn app.main:app --host :: --port 8000 --proxy-headers --forwarded-allow-ips '*'
