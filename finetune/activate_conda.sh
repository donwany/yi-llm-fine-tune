#!/bin/bash

conda create -n dev_env python=3.10 -y
conda activate dev_env

pip install torch==2.0.1 deepspeed==0.10 tensorboard transformers datasets sentencepiece accelerate ray==2.7
