#!/bin/bash
#SBATCH --job-name=lidar_20pct
#SBATCH --output=/storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/slurm/lidar_20pct_%j.out
#SBATCH --error=/storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/slurm/lidar_20pct_%j.err
#SBATCH --time=12:00:00
#SBATCH --nodes=1
#SBATCH --gpus-per-node=h100:1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G

source ~/.bashrc
conda activate py38_mmdet3d

cd /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/external/mmdetection3d
echo "Working directory: $(pwd)"

LAST_CHECKPOINT_FILE="/storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/external/mmdetection3d/work_dirs/lidar_baseline_nuscenes_20pct/last_checkpoint"

if [ -f "$LAST_CHECKPOINT_FILE" ]; then
    CHECKPOINT_PATH=$(cat "$LAST_CHECKPOINT_FILE")
    echo "Resuming training from $CHECKPOINT_PATH"
    python tools/train.py /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/external/mmdetection3d/configs/my_experiments/lidar_baseline_nuscenes_20pct.py \
        --resume "$CHECKPOINT_PATH"
else
    echo "No checkpoint found. Starting fresh training run."
    python tools/train.py /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/external/mmdetection3d/configs/my_experiments/lidar_baseline_nuscenes_20pct.py
fi
