#!/bin/bash
source /home/orlando/miniconda3/bin/activate allennlp

HOME="/home/orlando"
DATASET="$HOME/datasets/ontonotes/conll-formatted-ontonotes-verbatlas"
PROJECT="$HOME/transformer-srl"

export SRL_TRAIN_DATA_PATH="$DATASET/data/train"
export SRL_VALIDATION_DATA_PATH="$DATASET/data/development"

CONFIG="$PROJECT/training_config/bert_base_ml.jsonnet"

free_mem=$(nvidia-smi --query-gpu=memory.free --format=csv -i 1 | grep -Eo [0-9]+)

echo "$free_mem MB"
while [ $free_mem -lt 10000 ]; do
    free_mem=$(nvidia-smi --query-gpu=memory.free --format=csv -i 1 | grep -Eo [0-9]+)
    sleep 5
done

echo "GPU finally free, training..."

allennlp train $CONFIG -s models/bert_base_ml_va --include-package transformer_srl # --recover
