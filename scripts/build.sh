#!/usr/bin/env bash
# Build the Tether Docker image
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== Building Tether Docker image ==="
docker build -t tether:latest "$PROJECT_DIR"
echo "=== Build complete ==="
