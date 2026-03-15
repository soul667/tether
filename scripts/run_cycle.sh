#!/usr/bin/env bash
# Run the autonomous play cycle with the Tether Docker container
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== Running autonomous play cycle ==="
docker run --rm \
    --network host \
    -v "${PROJECT_DIR}/data_real:/app/data_real" \
    -v "${PROJECT_DIR}/cache:/app/cache" \
    -v "${PROJECT_DIR}/conf:/app/conf" \
    -e PYTHONUNBUFFERED=1 \
    tether:latest \
    python runner.py mode=cycle
