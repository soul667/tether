#!/usr/bin/env bash
# Validate the Docker environment by importing all dependencies and standalone modules
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

# Modules that don't require live RPC connections
import warp_trajectory
import extract_keypoint_trajectory
import query_gemini, ucb
import utils.geometry_utils, utils.calibration_utils
import utils.annotation_utils, utils.drawing_utils
import utils.misc_utils, utils.timer_utils
print('All standalone modules imported successfully.')

# runner and run_correspondence connect to RPC servers at import time,
# so they can only be validated when GeoAware/MASt3R servers are running.
print('Note: runner.py and run_correspondence.py require live RPC servers.')
print('Environment validation passed!')
"
echo "=== Validation complete ==="
