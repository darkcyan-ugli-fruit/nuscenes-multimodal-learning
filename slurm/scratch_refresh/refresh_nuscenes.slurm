#!/bin/bash

# ============================================================
# Scratch Refresh Job (UBELIX)
# ------------------------------------------------------------
# Purpose:
#   Refresh timestamps of all files in the nuScenes dataset
#   to prevent deletion from scratch storage (30-day policy).
#
# Usage:
#   Submit job:
#     sbatch slurm/scratch_refresh/refresh_nuscenes.slurm
#
#   Check job status:
#     squeue -u $USER
#
#   Monitor progress (logs):
#     tail -f slurm/scratch_refresh/job_<jobid>.out
#
#   Check errors:
#     cat slurm/scratch_refresh/job_<jobid>.err
#
#   Check completion status:
#     sacct -j <jobid> --format=JobID,State
#
#   Check a single file
#     ls /rs_scratch/users/ae04q066/nuscenes_full | head
#     stat /rs_scratch/users/ae04q066/nuscenes_full/<file>
#
# Test (run interactively without Slurm):
#   bash slurm/scratch_refresh/refresh_nuscenes.slurm
#
# Notes:
#   - This job is I/O-bound (no GPU required)
#   - Safe to rerun (touch is idempotent)
#   - Recommended every 2–3 weeks
# ============================================================

#SBATCH --job-name=scratch_refresh
#SBATCH --output=/storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/slurm/scratch_refresh/job_%j.out
#SBATCH --error=/storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/slurm/scratch_refresh/job_%j.err
#SBATCH --time=12:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --partition=epyc2

set -euo pipefail

TARGET="/rs_scratch/users/ae04q066/nuscenes_full"

echo "Start time: $(date)"
echo "Target: $TARGET"

total=$(find "$TARGET" -type f | wc -l)
echo "Total files: $total"

find "$TARGET" -type f -print0 | xargs -0 -n 1000 bash -c '
    touch "$@"
    echo "$(date): processed batch of $# files"
' _

echo "Finished at: $(date)"