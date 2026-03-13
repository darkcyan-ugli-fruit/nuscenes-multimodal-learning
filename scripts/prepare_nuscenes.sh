#!/usr/bin/env bash
set -e

source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate nuscenes-mmdet3d

cd external/mmdetection3d

python tools/create_data.py nuscenes \
    --root-path ../../data/sets/nuscenes \
    --out-dir ../../data/sets/nuscenes \
    --extra-tag nuscenes \
    --version v1.0-mini

cd ../..

echo "nuScenes mini metadata created."