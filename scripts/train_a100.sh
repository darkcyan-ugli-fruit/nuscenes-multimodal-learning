#!/bin/bash
#SBATCH --account=gratis
#SBATCH --partition=gpu-invest
#SBATCH --qos=job_gpu_preemptable
#SBATCH --job-name=lidar_baseline
#SBATCH --gres=gpu:a100:1
#SBATCH --nodes=1
#SBATCH --time=06:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --output=/storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/logs/%x_%j.out

set -e

echo "Starting job on $(hostname)"
echo "Start time: $(date)"

source ~/.bashrc
conda activate py38_mmdet3d

mkdir -p /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/logs

cd /storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/external/mmdetection3d

echo "Python: $(which python)"
echo "Working directory: $(pwd)"
nvidia-smi

python tools/train.py configs/my_experiments/lidar_baseline_nuscenes_fast.py --resume

echo "End time: $(date)"