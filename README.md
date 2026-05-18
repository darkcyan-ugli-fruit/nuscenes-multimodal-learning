# Multimodal 3D Object Detection on nuScenes:
# CenterPoint vs BEVFusion on Reduced Dataset Subsets

## Project Overview

This project investigates multimodal 3D object detection for autonomous driving using the nuScenes dataset. The work focuses on comparing a LiDAR-only baseline with a camera–LiDAR fusion approach through controlled experiments on reduced dataset subsets.

### nuScenes Dataset

The nuScenes dataset is a large-scale multimodal autonomous driving dataset composed of 1000 driving scenes including:
- LiDAR data
- Multi-view camera data
- Radar data
- Global Positioning System (GPS) information
- High-definition semantic map information
- 3D object annotations

The dataset provides:
- 6 cameras
- 1 LiDAR sensor
- 5 radar sensors
- full 360° sensor coverage around the ego vehicle

![](https://www.nuscenes.org/static/media/data.9ef46c59.png)

The full train/validation dataset contains:
- approximately 1.4 million camera images
- more than 390,000 LiDAR sweeps
- approximately 1.3 million radar point clouds

nuScenes annotations are provided on keyframes sampled at 2 Hz (one annotated frame every 0.5 seconds).

The dataset includes:
- daytime and nighttime driving
- rainy and clear weather conditions
- urban driving scenes from Boston and Singapore

The nuScenes test set does not provide public annotations, requiring prediction submission to the official nuScenes evaluation server for final benchmark evaluation.

### nuScenes Tasks

The nuScenes benchmark includes several autonomous driving tasks:
- Detection: 3D object detection and localization
- Tracking: temporal association of detected objects across frames
- Prediction: forecasting future trajectories of dynamic agents
- LiDAR Segmentation: point-wise semantic segmentation of LiDAR data
- Panoptic Segmentation: joint semantic and instance segmentation
- Planning: autonomous driving trajectory planning

### 3D Object Detection Task

The task considered in this project is 3D object detection for autonomous driving.

The objective is to detect relevant traffic participants surrounding the ego vehicle and estimate:
- object class
- 3D position
- object dimensions
- orientation in 3D space

The benchmark evaluates detection performance using multiple sensing modalities:
- LiDAR: geometric structure and accurate distance estimation
- Cameras: semantic, texture, and appearance information
- Radar: complementary range and motion information

The detection task must operate under diverse urban driving conditions including:
- varying object distances
- occlusions
- low visibility conditions
- dense traffic scenes
- dynamic environments

The final objective is to place accurate 3D bounding boxes around surrounding objects while maintaining robust detection performance across all driving scenarios.

### Project Scope

This project compares:
- CenterPoint, a LiDAR-based 3D object detection baseline
- BEVFusion, a multimodal fusion framework combining camera and LiDAR information in bird’s-eye-view (BEV) space

Due to the large storage and computational requirements of the full dataset, reduced subsets (20% and 40%) were generated to accelerate experimentation while maintaining representative training conditions.

The project was implemented using MMDetection3D and PyTorch, with training executed on Simple Linux Utility for Resource Management (SLURM)-based High Performance Computing (HPC) infrastructure using NVIDIA RTX 4090 and NVIDIA A100 Graphics Processing Unit (GPU) platforms.

### Evaluation Metrics

Model evaluation was performed using the official nuScenes validation metrics including:
- NuScenes Detection Score (NDS)
- mean Average Precision (mAP)
- mean Average Translation Error (mATE)
- mean Average Scale Error (mASE)
- mean Average Orientation Error (mAOE)
- mean Average Velocity Error (mAVE)
- mean Average Attribute Error (mAAE)

## Objectives

The objective of this project was to investigate multimodal perception for autonomous driving using the nuScenes dataset, with a particular focus on 3D object detection and sensor fusion.

The work focused on:
- performing exploratory data analysis (EDA) of the nuScenes sensing modalities and annotations
- studying the characteristics and interactions of different sensing modalities
- comparing unimodal and multimodal 3D object detection approaches
- evaluating the impact of sensor fusion on detection performance

## Repository Structure

## Repository Structure

```text
.
├── cache/                              # Cached full-dataset feature DataFrames used to avoid expensive recomputation
├── data/                               # nuScenes dataset and generated subsets
├── external/
│   ├── mmcv/                           # MMCV dependency repository
│   └── mmdetection3d/                  # OpenMMLab 3D object detection framework
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

## Dataset

The official nuScenes train/validation split contains:
- 700 training scenes
- 150 validation scenes

Training on the full dataset typically requires multiple Graphics Processing Units (GPUs), large storage capacity, and significant computational resources. In this project, experiments were conducted using a single GPU setup, motivating the use of reduced dataset subsets to maintain manageable training times and resource usage.

Due to the size of the dataset and storage quota limitations on the Ubelix High Performance Computing (HPC) cluster, the full dataset was stored on shared scratch storage (`/rs_scratch/users/ae04q066`) while persistent storage was reserved for code, environments, and lightweight datasets. Symbolic links were used inside the `data/` directory to connect the project structure with the dataset storage location without duplicating files.

To accelerate experimentation and reduce training time, reduced subsets containing 20% and 40% of the original training data were generated while preserving representative driving scenarios and object distributions.

The nuScenes test set does not provide public annotations. Final benchmark evaluation therefore requires prediction submission to the official nuScenes evaluation server.

## Models

Autonomous driving perception systems can use different sensor fusion strategies depending on the available modalities and the target task. Common approaches include:
- Camera-only perception
- LiDAR-only perception
- Radar-based perception
- Early fusion: combining raw sensor data before feature extraction
- Late fusion: combining predictions from independent sensor pipelines
- Bird’s-eye-view (BEV) fusion: combining sensor features in a shared spatial representation

This project focuses on comparing a LiDAR-only baseline with a camera–LiDAR fusion approach for 3D object detection.

LiDAR provides accurate geometric and distance information, while cameras provide rich semantic and texture information. Combining both modalities can improve object detection robustness and scene understanding, particularly in complex urban driving environments.

### CenterPoint

CenterPoint is a LiDAR-based 3D object detection framework using center-based object representation in bird’s-eye-view (BEV) space. In this project, it was used as the LiDAR-only baseline model.

Paper:
- [Center-based 3D Object Detection and Tracking](https://arxiv.org/abs/2006.11275)

### BEVFusion

BEVFusion is a multimodal 3D object detection framework combining camera and LiDAR information through a unified bird’s-eye-view (BEV) representation. The model was evaluated to study the impact of multimodal sensor fusion on detection performance.

Paper:
- [BEVFusion: Multi-Task Multi-Sensor Fusion with Unified Bird's-Eye View Representation](https://arxiv.org/abs/2205.13542)

## Experimental Setup

The experiments were implemented using:
- Python 3.8
- PyTorch
- MMDetection3D
- MMCV
- MMEngine
- nuScenes devkit

Training was executed on the Ubelix High Performance Computing (HPC) cluster using SLURM for GPU job scheduling and resource management.

Experiments were conducted using:
- NVIDIA RTX 4090 GPUs
- NVIDIA A100 GPUs

Separate experiment configurations were created for:
- CenterPoint baseline experiments
- BEVFusion experiments
- 20% and 40% dataset subsets

Training outputs, checkpoints, logs, and evaluation results were organized using dedicated experiment folders inside the MMDetection3D `work_dirs/` structure.

## Workflow

The project followed a structured experimentation pipeline:

1. Exploratory Data Analysis (EDA)
   - Analysis of the nuScenes dataset structure, annotations, and sensor modalities
   - Visualization of scenes, object classes, and spatial distributions

2. Dataset Preparation
   - Generation of reduced training subsets (20% and 40%)
   - Preparation of dataset metadata and training information files

3. Model Training
   - Training of the CenterPoint LiDAR-only baseline
   - Training of the BEVFusion camera–LiDAR fusion model
   - Execution on SLURM-managed GPU resources

4. Evaluation
   - Validation using official nuScenes detection metrics
   - Extraction and aggregation of performance metrics

5. Comparative Analysis
   - Comparison of LiDAR-only and multimodal fusion performance
   - Analysis of accuracy and computational tradeoffs

## Results

The experiments compared the CenterPoint LiDAR-only baseline with the BEVFusion camera–LiDAR fusion model on reduced nuScenes subsets containing 20% and 40% of the original training data.

### Exploratory Data Analysis (EDA) Findings

The exploratory data analysis was performed on the full nuScenes train/validation dataset to investigate modality behavior across object categories, distance ranges, and visibility conditions.

Key observations:
- Camera and LiDAR consistently provide stronger support than radar across most operating conditions.
- LiDAR becomes more reliable at long range and under high-visibility conditions.
- Pedestrians and small objects remain the most challenging categories.
- Camera and LiDAR exhibit complementary behavior across distance and visibility regimes.

These observations motivated the comparison between a LiDAR-only baseline and a camera–LiDAR fusion approach for 3D object detection.

### Global Performance

The best overall results were obtained with BEVFusion on the 40% subset:

| Model | Subset | NDS | mAP |
|---|---|---|---|
| CenterPoint | 20% | 0.487 | 0.398 |
| CenterPoint | 40% | 0.571 | 0.478 |
| BEVFusion | 20% | 0.469 | 0.449 |
| BEVFusion | 40% | **0.611** | **0.550** |

The best BEVFusion 40% experiment achieved:
- NuScenes Detection Score (NDS): **0.6113**
- mean Average Precision (mAP): **0.5499**

### Error Metrics

BEVFusion 40% also achieved the best global error metrics:
- mean Average Translation Error (mATE): 0.3126
- mean Average Scale Error (mASE): 0.2803
- mean Average Orientation Error (mAOE): 0.4777
- mean Average Velocity Error (mAVE): 0.3700
- mean Average Attribute Error (mAAE): 0.1966

### Per-Class Performance

The fusion model showed significant improvements for several object classes, particularly:
- bicycle
- motorcycle
- traffic cone
- pedestrian

The largest fusion gains were observed for:
- bicycle: +0.190 Average Precision (AP)
- motorcycle: +0.185 AP
- traffic cone: +0.175 AP

Some classes such as buses showed stronger performance with the LiDAR-only baseline, highlighting that multimodal fusion benefits can vary depending on object characteristics and sensor dependencies.

### Training Dynamics

Across all experiments:
- performance improved consistently over training epochs
- larger subsets improved both detection accuracy and stability
- BEVFusion achieved the highest final performance but required significantly greater computational resources
- reduced subsets enabled practical experimentation within a single GPU training setup

## Environment Setup

The project was developed with Python 3.8 and the OpenMMLab 3D detection stack.

Main framework versions:

| Package | Version |
|---|---:|
| MMEngine | 0.10.7 |
| MMDetection | 3.2.0 |
| MMDetection3D | 1.4.0 |

The environment can be recreated from the provided Conda files:

```bash
conda env create -f environment_ubelix.yml
conda activate py38_mmdet3d
```

Official MMDetection3D nuScenes setup guide:
https://github.com/open-mmlab/mmdetection3d/blob/main/docs/en/advanced_guides/datasets/nuscenes.md

## References

This project builds on the following works, frameworks, and official documentation:

### nuScenes

- [nuScenes Website](https://www.nuscenes.org/nuscenes#overview)
- [nuScenes: A multimodal dataset for autonomous driving](https://openaccess.thecvf.com/content_CVPR_2020/papers/Caesar_nuScenes_A_Multimodal_Dataset_for_Autonomous_Driving_CVPR_2020_paper.pdf)
- [nuScenes Devkit](https://github.com/nutonomy/nuscenes-devkit)

### Models

- [Center-based 3D Object Detection and Tracking](https://arxiv.org/abs/2006.11275)
- [CenterPoint MMDetection3D Configuration](https://github.com/open-mmlab/mmdetection3d/tree/main/configs/centerpoint)

- [BEVFusion: Multi-Task Multi-Sensor Fusion with Unified Bird's-Eye View Representation](https://arxiv.org/abs/2205.13542)
- [BEVFusion MMDetection3D Project](https://github.com/open-mmlab/mmdetection3d/tree/main/projects/BEVFusion)

### Frameworks

- [MMDetection3D nuScenes Dataset Preparation Guide](https://github.com/open-mmlab/mmdetection3d/blob/main/docs/en/advanced_guides/datasets/nuscenes.md)
- [MMDetection3D](https://github.com/open-mmlab/mmdetection3d)
- [MMEngine](https://github.com/open-mmlab/mmengine)
- [MMCV](https://github.com/open-mmlab/mmcv)