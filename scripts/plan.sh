#!/usr/bin/env bash
set -euo pipefail
ENVIRONMENT="${1:?usage: ./scripts/plan.sh <env>}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT/environments/$ENVIRONMENT"
if [[ -f backend.hcl ]]; then
  terraform init -reconfigure -backend-config=backend.hcl
else
  terraform init
fi
terraform plan -no-color
