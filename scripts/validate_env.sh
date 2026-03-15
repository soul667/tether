#!/usr/bin/env bash
# Validate the Docker environment by importing all modules
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== Validating Tether Docker environment ==="
docker run --rm \
    tether:latest \
    python -c "
import scipy, numpy, matplotlib, PIL, cv2, tqdm
import zerorpc, wandb, hydra, imageio, omegaconf, deepdiff
print('All Python dependencies imported successfully.')

import runner, run_correspondence, warp_trajectory
import annotate_trajectory, extract_keypoint_trajectory
import query_gemini, ucb
print('All project modules imported successfully.')
print('Environment validation passed!')
"
echo "=== Validation complete ==="
