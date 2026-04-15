#!/usr/bin/env bash
set -euo pipefail
ENVIRONMENT="${1:?usage: ./scripts/import.sh <env> <address> <id>}"
ADDRESS="${2:?terraform address required}"
RESOURCE_ID="${3:?resource id required}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT/environments/$ENVIRONMENT"
terraform init -reconfigure -backend-config=backend.hcl
terraform import "$ADDRESS" "$RESOURCE_ID"
