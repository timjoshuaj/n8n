# Officesphere n8n – Environment Variables (Staging vs Prod)

This file documents how we configure the **same n8n container image**
for **staging** and **production** using **environment variables only**.

No secrets (passwords, tokens, API keys) are stored in Git.
Secrets are injected on the servers via `.env` files or systemd unit overrides.

---

## 1. Common container settings

These apply to both environments unless overridden:

```bash
# Container listens on 5678 internally
N8N_PORT=5678
N8N_PROTOCOL=https

# n8n is mounted under a sub-path on nginx
N8N_PATH=/n8n/

# Database type
DB_TYPE=postgresdb
DB_POSTGRESDB_PORT=5432
````

---

## 2. Staging – staging.officesphere.ai

Staging URL: `https://staging.officesphere.ai/n8n/`
DB host: `10.20.0.20`
DB name: `n8n_staging`
DB user: `n8n_app`

```bash
# ---- URLs / Host ----
N8N_HOST=staging.officesphere.ai
N8N_EDITOR_BASE_URL=https://staging.officesphere.ai/n8n/
WEBHOOK_URL=https://staging.officesphere.ai/n8n/

# ---- Database ----
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=10.20.0.20
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_DATABASE=n8n_staging
DB_POSTGRESDB_USER=n8n_app
DB_POSTGRESDB_PASSWORD=__SET_ON_SERVER__

# ---- Security ----
# Basic auth for the n8n editor (on top of VPN + nginx)
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=__SET_ON_SERVER__
N8N_BASIC_AUTH_PASSWORD=__SET_ON_SERVER__

# Optional logging / rate limiting knobs (set later as needed)
# N8N_LOG_LEVEL=info
# N8N_LOG_OUTPUT=console
```

---

## 3. Production – app.officesphere.ai

Prod URL: `https://app.officesphere.ai/n8n/`
DB host: `10.20.0.20`
DB name: `n8n_prod`
DB user: `n8n_app`

```bash
# ---- URLs / Host ----
N8N_HOST=app.officesphere.ai
N8N_EDITOR_BASE_URL=https://app.officesphere.ai/n8n/
WEBHOOK_URL=https://app.officesphere.ai/n8n/

# ---- Database ----
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=10.20.0.20
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_DATABASE=n8n_prod
DB_POSTGRESDB_USER=n8n_app
DB_POSTGRESDB_PASSWORD=__SET_ON_SERVER__

# ---- Security ----
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=__SET_ON_SERVER__
N8N_BASIC_AUTH_PASSWORD=__SET_ON_SERVER__

# Optional logging / rate limiting knobs (set later as needed)
# N8N_LOG_LEVEL=info
# N8N_LOG_OUTPUT=console
```

---

## 4. Runtime pattern

On each VM we will eventually:

* Create an n8n env file (not committed to Git), for example:

  * `/etc/n8n/n8n.staging.env`
  * `/etc/n8n/n8n.prod.env`

* Inject these into the n8n container or systemd service via:

  * `docker run --env-file=/etc/n8n/n8n.staging.env ...`
  * or a systemd unit with `EnvironmentFile=/etc/n8n/n8n.staging.env`

**Key point:**
The **image** is identical for staging and prod.
**Only the env vars differ**.
