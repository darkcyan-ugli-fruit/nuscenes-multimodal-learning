#!/bin/bash
#
# Description:
#   bevfusion training on nuScenes (40pct subset)
#   using A100 on UBELIX.
#
# Usage:
#   sbatch /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/slurm/bevfusion_40pct/train_bevfusion_nuscenes_40pct_10ep_run1.slurm
#
# Check job:
#   squeue -u $USER
#
# Logs:
#   tail -f /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/slurm/bevfusion_40pct/job_<JOBID>.out
#   tail -f /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/slurm/bevfusion_40pct/job_<JOBID>.err
#
#SBATCH --job-name=bevfusion_40pct
#SBATCH --output=/storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/slurm/bevfusion_40pct/job_%j.out
#SBATCH --error=/storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/slurm/bevfusion_40pct/job_%j.err

#SBATCH --account=gratis
#SBATCH --partition=gpu-invest
#SBATCH --qos=job_gpu_preemptable

#SBATCH --time=06:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1

#SBATCH --gres=gpu:a100:1
#SBATCH --cpus-per-task=16
#SBATCH --mem=48G

set -eo pipefail

source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate py38_mmdet3d

cd /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/external/mmdetection3d
export PYTHONPATH="$PWD:$PYTHONPATH"

echo "========================================"
echo "Job ID: $SLURM_JOB_ID"
echo "Host: $(hostname)"
echo "Model: bevfusion"
echo "Subset: 40pct"
echo "GPU: a100"
echo "Max epochs: 10"
echo "Start time: $(date)"
echo "========================================"

which python
python --version
nvidia-smi

LAST_CHECKPOINT_FILE="/storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/external/mmdetection3d/work_dirs/bevfusion_nuscenes_40pct_10ep_run1/last_checkpoint"

if [ -f "$LAST_CHECKPOINT_FILE" ]; then
    CHECKPOINT_PATH=$(cat "$LAST_CHECKPOINT_FILE")
    echo "Resuming from $CHECKPOINT_PATH"

    python tools/train.py /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/external/mmdetection3d/configs/my_experiments/bevfusion_nuscenes_40pct.py \
        --work-dir /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/external/mmdetection3d/work_dirs/bevfusion_nuscenes_40pct_10ep_run1 \
        --resume "$CHECKPOINT_PATH"

else
    echo "Starting fresh training"

    python tools/train.py /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/external/mmdetection3d/configs/my_experiments/bevfusion_nuscenes_40pct.py \
        --work-dir /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/external/mmdetection3d/work_dirs/bevfusion_nuscenes_40pct_10ep_run1
fi
