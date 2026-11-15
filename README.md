# Homelable on Railway

[Homelable](https://github.com/Pouzor/homelable) (by Pouzor, MIT) — draw and document your homelab: an interactive canvas of hosts, VMs, containers and links, with racks, floor plans, documentation, live status, and imports from Proxmox, Unraid and Zigbee2MQTT. Deploy on Railway with one click.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/TEMPLATE_CODE)

## What this template runs

| Service | Image | Notes |
|---|---|---|
| `frontend` | `ghcr.io/onepush-dev/homelable-frontend:3.7.1` | Official SPA + nginx, listening on 8080 (public domain). Proxies `/api`, `/ws`, `/docs` to the backend over the private network. |
| `backend` | `ghcr.io/onepush-dev/homelable-backend:3.7.1` | Official FastAPI backend on `[::]:8080`, private only. Volume at `/app/data` (SQLite DB + uploads). |

Both images are the official upstream 3.7.1 images, app unmodified, plus small Railway wrappers.

## Variables

| Service | Variable | Value | Notes |
|---|---|---|---|
| backend | `HOMELABLE_ADMIN_PASSWORD` | generated per deploy | Password for user `admin`. Hashed with bcrypt at boot (replaces upstream's default `admin`/`admin`). |
| backend | `SECRET_KEY` | generated per deploy | Signs session tokens (JWT). |
| backend | `CORS_ORIGINS` | `["https://<frontend domain>"]` | Browser origin allowed by the API. |

Baked into the backend image: `SQLITE_PATH=/app/data/homelab.db`, `AUTH_MODE=local`, `AUTH_USERNAME=admin`, `SCANNER_RANGES=[]`.

## Notes

- Sign in at the frontend domain as `admin` with `HOMELABLE_ADMIN_PASSWORD` (backend service → Variables).
- Railway is not on your LAN: the nmap network scan and ping status checks cannot reach private homelab addresses. Build the canvas by hand, import YAML, or use the Proxmox/Unraid importers against hosts reachable from the internet. Status checks work for public endpoints.
- Optional extras from `.env.example` (LIVEVIEW_KEY, PROXMOX_*, GIT_SYNC_*, HOMEPAGE_API_KEY, ...) can be added as backend variables.
- Not affiliated with the Homelable project.
