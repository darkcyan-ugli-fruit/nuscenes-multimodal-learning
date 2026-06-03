# Multimodal 3D Object Detection on nuScenes
## CenterPoint vs BEVFusion on Reduced Dataset Subsets

**Author:** Adyl El Guamra  
**Program:** CAS Advanced Machine Learning, University of Bern  
**Year:** 2026

## Project Overview

This project investigates multimodal 3D object detection for autonomous driving using the nuScenes dataset.

The objective is to compare:

- **CenterPoint** — a LiDAR-only 3D object detector
- **BEVFusion** — a camera–LiDAR fusion framework operating in Bird's-Eye View (BEV) space

To enable experimentation on limited computational resources, reduced training subsets containing **20%** and **40%** of the original nuScenes training set were generated. The models were trained and evaluated using the OpenMMLab ecosystem (MMDetection3D) on GPU-based HPC infrastructure.

### Dataset

The experiments use the **nuScenes** autonomous driving dataset, which provides synchronized multimodal sensor data with full 360° coverage around the ego vehicle:

- 6 cameras
- 1 LiDAR sensor
- 5 radar sensors
- GPS and vehicle pose information
- HD semantic maps
- 3D object annotations

The dataset contains urban driving scenes collected in **Boston** and **Singapore** under diverse traffic, weather, and lighting conditions.

![](https://www.nuscenes.org/static/media/data.9ef46c59.png)

### Task

The project focuses on **3D object detection**, where the goal is to detect surrounding traffic participants and estimate:

- object class
- 3D position
- dimensions
- orientation

Performance is evaluated using the official nuScenes detection metrics:

- NDS (NuScenes Detection Score)
- mAP (mean Average Precision)
- mATE (Translation Error)
- mASE (Scale Error)
- mAOE (Orientation Error)
- mAVE (Velocity Error)
- mAAE (Attribute Error)

## Objectives

The objective of this project was to investigate the impact of multimodal sensor fusion on 3D object detection performance for autonomous driving.

The work focused on:

- performing exploratory data analysis (EDA) of the nuScenes dataset and sensing modalities
- studying the characteristics of camera, LiDAR, and radar data
- comparing a LiDAR-only baseline (**CenterPoint**) with a camera–LiDAR fusion approach (**BEVFusion**)
- evaluating the effect of sensor fusion on detection performance across object classes
- assessing the feasibility of training state-of-the-art 3D detection models on reduced dataset subsets (20% and 40%)

The final goal was to determine whether multimodal fusion provides measurable performance improvements over a LiDAR-only approach under constrained computational resources.

## Repository Structure

```text
.
├── cache/                              # Cached EDA outputs and intermediate datasets
├── data/                               # nuScenes dataset and generated subsets
├── external/
│   ├── mmcv/                           # MMCV dependency
│   └── mmdetection3d/                  # OpenMMLab 3D detection framework
│       ├── configs/
│       │   └── my_experiments/         # Custom CenterPoint and BEVFusion configurations
│       └── work_dirs/                  # Training logs, checkpoints, and outputs
├── notebooks/                          # EDA, dataset preparation, training, and evaluation
├── results/                            # Final metrics, tables, and figures
├── slurm/                              # HPC job scripts and experiment folders
├── environment.yml                     # Local Conda environment
├── environment_ubelix.yml              # Ubelix HPC Conda environment
└── README.md
```

Dataset preparation follows the official MMDetection3D nuScenes guide:

https://github.com/open-mmlab/mmdetection3d/blob/main/docs/en/advanced_guides/datasets/nuscenes.md


## Dataset

The official nuScenes train/validation split contains:

- 700 training scenes
- 150 validation scenes

Training on the full dataset requires substantial storage and computational resources. Since this project was conducted using a single-GPU setup, reduced training subsets were created to enable faster experimentation while preserving representative driving scenarios and object distributions.

The following subsets were generated from the original training set:

- 20% subset
- 40% subset

Due to storage quota limitations on the Ubelix HPC cluster, the full nuScenes dataset was stored on shared scratch storage. Symbolic links were used to connect the project `data/` directory to the dataset location required by MMDetection3D.

All model evaluation was performed on the official nuScenes validation set.

> **Note:** The nuScenes test set does not provide public annotations. Final benchmark evaluation therefore requires submission to the official nuScenes evaluation server.

## Models

This project compares a LiDAR-only baseline with a multimodal camera–LiDAR fusion approach for 3D object detection.

### CenterPoint

CenterPoint is a LiDAR-based 3D object detection framework that represents objects by their center points in Bird's-Eye View (BEV) space. It was used as the baseline model to evaluate the performance of LiDAR-only perception.

**Reference:**
- [Center-based 3D Object Detection and Tracking](https://arxiv.org/abs/2006.11275)

### BEVFusion

BEVFusion is a multimodal 3D object detection framework that combines camera and LiDAR information within a unified Bird's-Eye View (BEV) representation. It was evaluated to measure the impact of multimodal sensor fusion on detection performance.

**Reference:**
- [BEVFusion: Multi-Task Multi-Sensor Fusion with Unified Bird's-Eye View Representation](https://arxiv.org/abs/2205.13542)

### Motivation

The exploratory data analysis (EDA) performed on the nuScenes dataset indicated that camera and LiDAR modalities provide complementary information for 3D object detection. These observations motivated the comparison between a LiDAR-only approach (CenterPoint) and a camera–LiDAR fusion approach (BEVFusion).

## Experimental Setup

The experiments were implemented using the OpenMMLab 3D detection stack and trained on the Ubelix HPC cluster using SLURM for resource management.

### Software

| Component | Version |
|------------|---------:|
| Python | 3.8 |
| PyTorch | 2.4.1 |
| MMEngine | 0.10.7 |
| MMDetection | 3.2.0 |
| MMDetection3D | 1.4.0 |

### Hardware

Experiments were conducted on single-GPU nodes using:

- NVIDIA RTX 4090 GPUs
- NVIDIA A100 GPUs

### Experiments

Four experiments were performed:

| Model | Training Subset |
|---------|---------:|
| CenterPoint | 20% |
| CenterPoint | 40% |
| BEVFusion | 20% |
| BEVFusion | 40% |

Training outputs, checkpoints, logs, and evaluation results were stored within the MMDetection3D `work_dirs/` directory.

## Workflow

The project followed the workflow below:

1. **Exploratory Data Analysis (EDA)**
   - Analysis of sensor modalities, annotations, and object distributions
   - Investigation of modality behavior across distance and visibility conditions

2. **Dataset Preparation**
   - Generation of reduced training subsets (20% and 40%)
   - Creation of MMDetection3D-compatible dataset files

3. **Model Training**
   - Training of CenterPoint (LiDAR-only)
   - Training of BEVFusion (camera–LiDAR fusion)

4. **Evaluation**
   - Validation using official nuScenes detection metrics
   - Aggregation of experiment results

5. **Comparative Analysis**
   - Comparison of detection performance across models and dataset sizes
   - Analysis of multimodal fusion benefits and trade-offs

   ## Results

### EDA Findings

The exploratory data analysis performed on the full nuScenes train/validation dataset revealed that camera and LiDAR modalities provide complementary information for 3D object detection.

Key observations included:

- camera and LiDAR consistently provided stronger support than radar across most operating conditions
- LiDAR became increasingly reliable at long range and under high-visibility conditions
- pedestrians and small objects remained the most challenging categories
- modality strengths varied across distance and visibility regimes

These findings motivated the comparison between a LiDAR-only baseline (CenterPoint) and a camera–LiDAR fusion approach (BEVFusion).

### Global Performance

| Model | Subset | NDS | mAP |
|---|---|---:|---:|
| CenterPoint | 20% | 0.4851 | 0.3980 |
| BEVFusion | 20% | 0.4686 | 0.4489 |
| CenterPoint | 40% | 0.5712 | 0.4773 |
| BEVFusion | 40% | **0.6092** | **0.5490** |

The best overall performance was achieved by **BEVFusion trained on the 40% subset**, reaching:

- **NuScenes Detection Score (NDS):** 0.6092
- **mean Average Precision (mAP):** 0.5490

Increasing the training subset from 20% to 40% improved performance for both models, with the largest gains observed for BEVFusion.

### Per-Class Performance

Average Precision (**AP**) measures the detection performance of a single object class by combining precision and recall across different confidence thresholds. Higher values indicate better detection performance.

The largest gains obtained by BEVFusion over CenterPoint were observed for:

| Class | AP Gain (20%) | AP Gain (40%) |
|---|---:|---:|
| Bicycle | +0.110 | **+0.193** |
| Motorcycle | +0.142 | **+0.184** |
| Traffic Cone | +0.228 | **+0.173** |

These results indicate that camera–LiDAR fusion provides the greatest benefit for smaller and more challenging object classes, where semantic information from camera images complements LiDAR geometry.

### Key Findings

- Increasing the training subset from 20% to 40% consistently improved detection performance.
- BEVFusion achieved the highest overall detection accuracy.
- Camera–LiDAR fusion provided the largest gains for bicycles, motorcycles, and traffic cones.
- Reduced subsets enabled practical experimentation on a single-GPU training setup while preserving meaningful model comparisons.

## References

### Dataset

- [nuScenes Website](https://www.nuscenes.org/nuscenes#overview)
- [nuScenes: A Multimodal Dataset for Autonomous Driving](https://openaccess.thecvf.com/content_CVPR_2020/papers/Caesar_nuScenes_A_Multimodal_Dataset_for_Autonomous_Driving_CVPR_2020_paper.pdf)
- [nuScenes Devkit](https://github.com/nutonomy/nuscenes-devkit)

### Models

- [Center-based 3D Object Detection and Tracking](https://arxiv.org/abs/2006.11275)
- [BEVFusion: Multi-Task Multi-Sensor Fusion with Unified Bird's-Eye View Representation](https://arxiv.org/abs/2205.13542)

### Framework

- [MMDetection3D](https://github.com/open-mmlab/mmdetection3d)