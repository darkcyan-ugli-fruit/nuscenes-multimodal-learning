# Multimodal 3D Object Detection on nuScenes:
# CenterPoint vs BEVFusion on Reduced Dataset Subsets

## Project Overview

This project investigates multimodal 3D object detection for autonomous driving using the nuScenes dataset. The work focuses on comparing a LiDAR-only baseline with a camera–LiDAR fusion approach through controlled experiments on reduced dataset subsets.

The nuScenes dataset is a large-scale multimodal autonomous driving dataset composed of 1000 driving scenes including LiDAR, camera, radar, Global Positioning System (GPS), and map information. The full train/validation dataset contains approximately 1.4 million camera images and more than 390,000 LiDAR sweeps, representing several hundred gigabytes of data storage.

Due to the large storage and computational requirements of the full dataset, reduced subsets (20% and 40%) were generated to accelerate experimentation while maintaining representative training conditions.

Two state-of-the-art architectures were evaluated:
- CenterPoint, a LiDAR-based 3D object detection baseline
- BEVFusion, a multimodal fusion framework combining camera and LiDAR information in bird’s-eye-view (BEV) space

The project was implemented using MMDetection3D and PyTorch, with training executed on SLURM-based High Performance Computing (HPC) infrastructure using NVIDIA RTX 4090 and NVIDIA A100 Graphics Processing Unit (GPU) platforms.

Model evaluation was performed using the official nuScenes validation metrics including:
- NuScenes Detection Score (NDS)
- mean Average Precision (mAP)
- mean Average Translation Error (mATE)
- mean Average Scale Error (mASE)
- mean Average Orientation Error (mAOE)
- mean Average Velocity Error (mAVE)
- mean Average Attribute Error (mAAE)

The nuScenes test set does not provide public annotations. Final test evaluation therefore requires prediction submission to the official nuScenes evaluation server.

## Objectives

The objective of this project was to evaluate the impact of multimodal sensor fusion on 3D object detection performance using the nuScenes dataset.

The project focused on:
- Comparing a LiDAR-only baseline with a camera–LiDAR fusion approach
- Evaluating the CenterPoint baseline and the BEVFusion model
- Conducting controlled experiments on reduced nuScenes subsets (20% and 40%)
- Analyzing performance using standard nuScenes evaluation metrics

## Repository Structure

```text
.
├── data/                               # nuScenes dataset and generated subsets
├── external/
│   ├── mmcv/                           # MMCV dependency repository
│   └── mmdetection3d/
│       ├── configs/
│       │   └── my_experiments/         # Custom CenterPoint and BEVFusion experiment configurations
│       └── work_dirs/                  # Training outputs, checkpoints, and experiment results
├── notebooks/                          # Jupyter notebooks for EDA, training, and evaluation
├── results/                            # Evaluation outputs and generated figures
├── slurm/                              # SLURM job scripts and HPC experiment folders
├── environment.yml                     # Conda environment definition
├── environment_ubelix.yml              # Ubelix HPC environment definition
└── README.md
```


next