# Ubelix environment
module load Anaconda3 
eval "$(conda shell.bash hook)"
conda activate py38_mmdet3d

# nuscenes-multimodal-learning



git clone https://github.com/open-mmlab/mmdetection3d.git external/mmdetection3d