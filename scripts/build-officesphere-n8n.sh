#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./scripts/build-officesphere-n8n.sh staging
#   ./scripts/build-officesphere-n8n.sh prod
#   ./scripts/build-officesphere-n8n.sh local   # default if no arg
#
# This builds the n8n image from the current repo using the Dockerfile
# in the root of this fork.

ENVIRONMENT="${1:-local}"   # staging | prod | local

GIT_SHA="$(git rev-parse --short HEAD)"
IMAGE_NAME="officesphere-n8n:${ENVIRONMENT}-${GIT_SHA}"

echo "Building n8n image: ${IMAGE_NAME}"
docker build -t "${IMAGE_NAME}" .

echo
echo "Done."
echo "Example run command:"
echo "  docker run --env-file=/etc/n8n/n8n.${ENVIRONMENT}.env -p 5678:5678 ${IMAGE_NAME}"
