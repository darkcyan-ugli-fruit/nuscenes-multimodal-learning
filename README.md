## Environment Setup (UBELIX)

### Load Conda Environment

```bash
module load Anaconda3
eval "$(conda shell.bash hook)"
conda activate py38_mmdet3d

```

## Scratch Storage Refresh (UBELIX)

The nuScenes dataset is stored on UBELIX scratch storage:

/rs_scratch/users/ae04q066/nuscenes_full

Scratch storage automatically deletes files that have not been accessed or modified for 30 days.  
To prevent accidental data loss, I periodically refresh file timestamps.

https://hpc-unibe-ch.github.io/storage/#__tabbed_1_4 

### Approach

I use a Slurm job that applies:

find <dataset_path> -type f -exec touch {} +

Explanation:
- `find` → recursively lists all files in the dataset directory  
- `-type f` → selects only files (not directories)  
- `touch` → updates file timestamps (marks them as recently used)  
- `-exec {} +` → applies the command in efficient batches  

### Why this is necessary

- The cleanup policy is applied per file, not per folder  
- Large datasets like nuScenes contain hundreds of thousands of files  
- Refreshing only a subset is unsafe → all files must be updated  

### Implementation

Scripts are located in:

slurm/scratch_refresh/

These jobs:
- run on CPU (no GPU required)  
- are scheduled via Slurm  
- optionally log progress for long runs  

### Usage

I submit the refresh job with:

```bash
sbatch slurm/scratch_refresh/refresh_nuscenes.slurm
```

## nuscenes-multimodal-learning



git clone https://github.com/open-mmlab/mmdetection3d.git external/mmdetection3d


## mmcv install

TODO