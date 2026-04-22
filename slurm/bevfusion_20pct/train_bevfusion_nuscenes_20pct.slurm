#!/bin/bash
#
# Description:
#   SLURM submission script for BEVFusion training on nuScenes (20% subset).
#   Runs on a single A100 GPU with automatic checkpoint resume and
#   preemption-safe requeue behavior.
#
# Usage:
#   sbatch /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/slurm/bevfusion_20pct/train_bevfusion_nuscenes_20pct.slurm
#
# Check job status:
#   squeue -u $USER
#
# Follow logs:
#   tail -f /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/slurm/bevfusion_20pct/job_<JOBID>.out
#   tail -f /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/slurm/bevfusion_20pct/job_<JOBID>.err
#
# Check whether a checkpoint exists:
#   ls -lh /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/external/mmdetection3d/work_dirs/bevfusion_nuscenes_20pct
#   cat /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/external/mmdetection3d/work_dirs/bevfusion_nuscenes_20pct/last_checkpoint
#
# Resume behavior test:
#   1. Submit the job with:
#        sbatch /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/slurm/bevfusion_20pct/train_bevfusion_nuscenes_20pct.slurm
#   2. Wait until a checkpoint is written.
#   3. Cancel the job manually with:
#        scancel <JOBID>
#   4. Submit the same script again:
#        sbatch /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/slurm/bevfusion_20pct/train_bevfusion_nuscenes_20pct.slurm
#   5. Confirm that the log contains:
#        Resuming training from ...
#
#SBATCH --job-name=bevfusion_20pct
#SBATCH --output=/storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/slurm/bevfusion_20pct/job_%j.out
#SBATCH --error=/storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/slurm/bevfusion_20pct/job_%j.err
#SBATCH --time=12:00:00
#SBATCH --nodes=1
#SBATCH --gpus-per-node=a100:1
#SBATCH --cpus-per-task=16
#SBATCH --mem=48G
#SBATCH --qos=job_gpu_preemptable
#SBATCH --signal=SIGUSR1@120
#SBATCH --requeue

source ~/.bashrc
conda activate py38_mmdet3d

cd /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/external/mmdetection3d
export PYTHONPATH=$PWD:$PYTHONPATH
echo "Working directory: $(pwd)"

LAST_CHECKPOINT_FILE="/storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/external/mmdetection3d/work_dirs/bevfusion_nuscenes_20pct/last_checkpoint"

handle_signal() {
    echo "Received preemption signal. Exiting so Slurm can requeue."
    exit 0
}

trap handle_signal SIGUSR1

if [ -f "$LAST_CHECKPOINT_FILE" ]; then
    CHECKPOINT_PATH=$(cat "$LAST_CHECKPOINT_FILE")
    echo "Resuming training from $CHECKPOINT_PATH"
    python tools/train.py /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/external/mmdetection3d/configs/my_experiments/bevfusion_nuscenes_20pct.py \
        --resume "$CHECKPOINT_PATH"
else
    echo "No checkpoint found. Starting fresh training run."
    python tools/train.py /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/external/mmdetection3d/configs/my_experiments/bevfusion_nuscenes_20pct.py
fi
