#!/bin/bash
#
# Description:
#   CenterPoint LiDAR-only training on nuScenes (20% subset)
#   using RTX4090 on UBELIX.
#
# Usage:
#   sbatch /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/slurm/lidar_20pct/train_lidar_baseline_nuscenes_20pct_rtx4090_run2.slurm
#
# Check job:
#   squeue -u $USER
#
# Logs:
#   tail -f /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/slurm/lidar_20pct/job_<JOBID>.out
#   tail -f /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/slurm/lidar_20pct/job_<JOBID>.err
#
#SBATCH --job-name=lidar_20pct
#SBATCH --output=/storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/slurm/lidar_20pct/job_%j.out
#SBATCH --error=/storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/slurm/lidar_20pct/job_%j.err

#SBATCH --account=gratis
#SBATCH --partition=gpu-invest
#SBATCH --qos=job_gpu_preemptable

#SBATCH --time=06:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1

# GPU selection
#SBATCH --gres=gpu:rtx4090:1
##SBATCH --gres=gpu:a100:1
##SBATCH --gres=gpu:h100:1



#SBATCH --cpus-per-task=16
#SBATCH --mem=48G

set -eo pipefail

# Proper conda initialization
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate py38_mmdet3d

cd /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/external/mmdetection3d
export PYTHONPATH="$PWD:$PYTHONPATH"

echo "========================================"
echo "Job ID: $SLURM_JOB_ID"
echo "Host: $(hostname)"
echo "Start time: $(date)"
echo "========================================"

which python
python --version
nvidia-smi

LAST_CHECKPOINT_FILE="/storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/external/mmdetection3d/work_dirs/lidar_baseline_nuscenes_20pct_rtx4090_run2/last_checkpoint"

if [ -f "$LAST_CHECKPOINT_FILE" ]; then
    CHECKPOINT_PATH=$(cat "$LAST_CHECKPOINT_FILE")
    echo "Resuming from $CHECKPOINT_PATH"
    python tools/train.py /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/external/mmdetection3d/configs/my_experiments/lidar_baseline_nuscenes_20pct.py         --work-dir /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/external/mmdetection3d/work_dirs/lidar_baseline_nuscenes_20pct_rtx4090_run2         --resume "$CHECKPOINT_PATH"
else
    echo "Starting fresh training"
    python tools/train.py /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/external/mmdetection3d/configs/my_experiments/lidar_baseline_nuscenes_20pct.py     --work-dir /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/external/mmdetection3d/work_dirs/lidar_baseline_nuscenes_20pct_rtx4090_run2
fi
