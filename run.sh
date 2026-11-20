#!/bin/bash
set -o pipefail
LOSS=$1
OPT=$2
LR=${3:-2e-4}
TAG=$4
EXTRA="${@:5}"
NAME=${LOSS}_${OPT}_lr${LR}${TAG:+_$TAG}_e30
COMMON="--data_path ./datasets --ann_path ./clip_train --train_file cc3m_train_subset.json --train_image_root cc3m_subset_100k --output_dir output/$NAME --init_model --use_amp --ita_type $LOSS --opt $OPT --lr $LR --tau_init 0.01 --sogclr_gamma 0.8 --eta_init 0.03 --sched cosine --no-distributed --epochs 30 $EXTRA"

mkdir -p results logs

python iSogCLR/bimodal_exps/clip.py $COMMON 2>&1 | tee logs/$NAME.log || { echo "TRAINING FAILED"; exit 1; }
cp output/$NAME/args.json results/${NAME}_args.json

python iSogCLR/bimodal_exps/clip.py $COMMON --evaluate --checkpoint output/$NAME/checkpoint_30.pth --zs_dataset imagenet --zs_datafolder ./datasets/imagenet/val 2>&1 | tee logs/${NAME}_eval_ep30.log
cp logs/${NAME}_eval_ep30.log results/

cd output/$NAME && ls checkpoint_*.pth | grep -vE 'checkpoint_(5|10|15|20|25|30)\.pth' | xargs -r rm -f
