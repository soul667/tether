#!/usr/bin/env bash
# Run a single rollout with the Tether Docker container
# Usage: ./run_single.sh <action_name>
# Example: ./run_single.sh bowl-table-shelf
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

ACTION="${1:?Usage: $0 <action_name>}"

echo "=== Running single rollout: action=${ACTION} ==="
docker run --rm \
    --network host \
    -v "${PROJECT_DIR}/data_real:/app/data_real" \
    -v "${PROJECT_DIR}/cache:/app/cache" \
    -v "${PROJECT_DIR}/conf:/app/conf" \
    -e PYTHONUNBUFFERED=1 \
    tether:latest \
    python runner.py mode=single "action=${ACTION}"
