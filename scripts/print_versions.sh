#!/usr/bin/env bash
set -euo pipefail

ENV_NAME="${1:-nuscenes-mmdet3d}"
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate "${ENV_NAME}"

python - <<'PY'
import torch
print("torch:", torch.__version__)
print("torch cuda:", torch.version.cuda)
print("cuda available:", torch.cuda.is_available())
PY

python -m pip show mmengine mmcv mmcv-lite mmdet mmdet3d nuscenes-devkit || true