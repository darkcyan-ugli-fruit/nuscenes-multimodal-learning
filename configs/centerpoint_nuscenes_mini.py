_base_ = '../external/mmdetection3d/configs/centerpoint/centerpoint_voxel01_second_secfpn_8xb4-cyclic-20e_nus-3d.py'

data_root = 'data/sets/nuscenes/'

train_dataloader = dict(
    batch_size=2,
    num_workers=2,
    dataset=dict(
        dataset=dict(
            data_root=data_root,
            ann_file='nuscenes_infos_train.pkl'
        )
    )
)

val_dataloader = dict(
    batch_size=1,
    num_workers=2,
    dataset=dict(
        data_root=data_root,
        ann_file='nuscenes_infos_val.pkl'
    )
)

test_dataloader = dict(
    batch_size=1,
    num_workers=2,
    dataset=dict(
        data_root=data_root,
        ann_file='nuscenes_infos_val.pkl'
    )
)

train_cfg = dict(
    by_epoch=True,
    max_epochs=5,
    val_interval=1
)

val_evaluator = dict(
    ann_file=data_root + 'nuscenes_infos_val.pkl'
)

test_evaluator = dict(
    ann_file=data_root + 'nuscenes_infos_val.pkl'
)

default_hooks = dict(
    checkpoint=dict(interval=1, max_keep_ckpts=3)
)

work_dir = './work_dirs/centerpoint_nuscenes_mini'