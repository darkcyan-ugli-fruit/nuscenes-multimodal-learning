#!/bin/bash
#SBATCH --job-name=scratch_refresh
#SBATCH --output=/storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/slurm/scratch_refresh/job_%j.out
#SBATCH --error=/storage/homefs/ae04q066/projects/nuscenes-multimodal-learning/slurm/scratch_refresh/job_%j.err
#SBATCH --time=02:00:00
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

count=0

find "$TARGET" -type f -print0 | while IFS= read -r -d '' f; do
    touch "$f"
    count=$((count + 1))

    if (( count % 10000 == 0 )); then
        echo "$(date): processed $count / $total files"
    fi
done

echo "Finished at: $(date)"