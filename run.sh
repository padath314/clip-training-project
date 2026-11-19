#!/bin/bash
LOSS=$1
OPT=$2
LR=${3:-2e-4}
NAME=${LOSS}_${OPT}_lr${LR}_e30
python iSogCLR/bimodal_exps/clip.py --data_path ./datasets --ann_path ./clip_train \
  --train_file cc3m_train_subset.json --train_image_root cc3m_subset_100k \
  --output_dir output/$NAME --init_model --use_amp \
  --ita_type $LOSS --opt $OPT --lr $LR --tau_init 0.01 --sogclr_gamma 0.8 --eta_init 0.03 \
  --sched cosine --no-distributed --epochs 30 2>&1 | tee logs/$NAME.log
