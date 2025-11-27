# Officesphere n8n container image
# - Built from our forked repo so CI can scan/tag it.
# - All environment-specific config (URLs, DB, auth) is injected at runtime via env vars.

FROM n8nio/n8n:latest

# Upstream already defines the entrypoint and CMD to run n8n
EXPOSE 5678
