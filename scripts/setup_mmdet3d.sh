#!/usr/bin/env bash
set -euo pipefail

ENV_NAME="${1:-nuscenes-mmdet3d}"
MMDET3D_DIR="external/mmdetection3d"
MMDET3D_BRANCH="dev-1.x"

echo "=== Activating conda env: ${ENV_NAME} ==="
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate "${ENV_NAME}"

echo "=== Python / pip ==="
python --version
python -m pip install -U pip setuptools wheel openmim

echo "=== Checking PyTorch ==="
python - <<'PY'
import sys
try:
    import torch
    print("torch version:", torch.__version__)
    print("torch cuda:", torch.version.cuda)
    print("cuda available:", torch.cuda.is_available())
except Exception as e:
    print("ERROR: PyTorch is not installed correctly.")
    print(e)
    sys.exit(1)
PY

echo "=== Cleaning conflicting OpenMMLab packages ==="
python -m pip uninstall -y mmcv mmcv-lite mmengine mmdet mmdet3d || true

echo "=== Installing OpenMMLab core dependencies ==="
mim install "mmengine>=0.8.0,<1.0.0"
mim install "mmcv>=2.0.0rc4,<2.2.0"
mim install "mmdet>=3.0.0rc5,<3.4.0"
python -m pip install -U nuscenes-devkit numba

echo "=== Cloning MMDetection3D if missing ==="
if [ ! -d "${MMDET3D_DIR}" ]; then
  git clone -b "${MMDET3D_BRANCH}" https://github.com/open-mmlab/mmdetection3d.git "${MMDET3D_DIR}"
else
  echo "Repo already exists at ${MMDET3D_DIR}"
fi

echo "=== Installing MMDetection3D (non-editable, safer) ==="
cd "${MMDET3D_DIR}"
git fetch origin
git checkout "${MMDET3D_BRANCH}"
python -m pip install -v . --no-build-isolation
cd ../..

echo "=== Verifying imports ==="
python - <<'PY'
modules = ["torch", "mmengine", "mmcv", "mmdet", "mmdet3d"]
for name in modules:
    mod = __import__(name)
    print(f"{name}: OK", getattr(mod, "__version__", "no __version__"))
PY

echo "=== Installed package summary ==="
python -m pip show torch mmengine mmcv mmdet mmdet3d nuscenes-devkit || true

echo "=== Done ==="
echo "If all imports above are OK, your MMDetection3D install is ready."