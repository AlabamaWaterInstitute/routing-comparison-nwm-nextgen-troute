#!/usr/bin/env bash
# =============================================================================
# flow_comparison.sh
#
# Run the flow comparison (flow_comparison.py) inside the flow-comparison
# Docker image.
#
# Paths can be overridden with environment variables:
#   REPO_DIR       Path to this repository (default: derived from script location)
#   HOST_DATA_DIR  Path to the t-route data directory (default: ${REPO_DIR}/t-route)
#
# Usage:
#   bash scripts/bash/flow_comparison.sh [extra flow_comparison.py args]
#   HOST_DATA_DIR=/path/to/t-route bash scripts/bash/flow_comparison.sh
# =============================================================================
set -eo pipefail

# Directory paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="${REPO_DIR:-$(cd "${SCRIPT_DIR}/../.." && pwd)}"
HOST_DATA_DIR="${HOST_DATA_DIR:-${REPO_DIR}/t-route}"
PYTHON_SCRIPT_DIR="${REPO_DIR}/scripts/python"

CONTAINER_REPO_DIR="/routing-comparison-nwm-nextgen-troute"
CONTAINER_DATA_DIR="/t-route"

echo "==> Running Flow Comparison..."
docker run --rm \
  -v "${HOST_DATA_DIR}:${CONTAINER_DATA_DIR}" \
  -v "${REPO_DIR}:${CONTAINER_REPO_DIR}" \
  -v "${PYTHON_SCRIPT_DIR}/flow_comparison.py:/app/flow_comparison.py" \
  -w /app \
  flow-comparison \
  /app/flow_comparison.py \
    --nwm-to-ngen-map "${CONTAINER_REPO_DIR}/data/gage_downstream_nwm_to_ngen_map.json" \
    --channel-forcing-dir "${CONTAINER_DATA_DIR}/channel_forcing" \
    --troute-output-dir "${CONTAINER_DATA_DIR}/outputs/troute" \
    --output-dir "${CONTAINER_DATA_DIR}/outputs/troute" \
    "$@"
