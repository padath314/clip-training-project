### Susan 11th November 2026
Dataset is here --> https://drive.google.com/drive/folders/1Wh-X0YHUoJCRdIS2hVFtRC6xU5JToqvz
Source Colab Notebook --> https://colab.research.google.com/drive/1FTF-cTcW11Gyrwu8uhTZOXgLsjp49Z9W?usp=sharing

**Done**
- Set up project repo `clip-training-project` locally with a Python venv (`.venv`)
- Downloaded and extracted all datasets:
  - `clip_train/`: cc3m_train_subset.json, coco_val.json, readme.md
  - `datasets/cc3m_subset_100k/cc_data/`: training images (100k)
  - `datasets/mscoco_val/`: retrieval validation
  - `datasets/imagenet/val/`: zero-shot validation (1000 classes)
- ImageNet val mirror (own Drive copy) ID: `1ZdThAM7B3w1KKDkQNPFXZLeiMICjotwr`
- Added `.gitignore` (data, venv, checkpoints, outputs)

**To fix next time**
- Mac has no NVIDIA GPU / CUDA: training must run on a GPU platform (HPRC / Kaggle / Colab Pro, TBD)
- venv is Python 3.14; recreate with 3.10/3.11 for PyTorch + requirements
- Set `PYTHONPATH` and `HUGGINGFACE_HUB_CACHE` in the shell (the notebook's `!export` doesn't persist)

**Reference benchmarks (bs 128, 30 epochs), our sanity target**
| Method | TR@1 | IR@1 | ImageNet ACC@1 | Avg |
|---|---|---|---|---|
| CLIP | 12.0 | 9.32 | 21.35 | 14.22 |
| SogCLR | 14.38 | 10.73 | 24.54 | 16.55 |

**Next**
- [ ] Verify cc3m JSON image paths match `cc_data/` layout
- [ ] Clone training code (`csce689_iSogCLR`, branch `project`)
- [ ] Pick GPU platform and set up env + data there
- [ ] Smoke test (2k subset, 1 epoch) + COCO and ImageNet eval
- [ ] Launch CLIP + AdamW baseline (30 epochs), then SogCLR + AdamW (gamma 0.8, tau 0.01)
- [ ] Thu sync with B: loss curves, time/epoch, val numbers

### Susan 17th November 2026
- Cloned iSogCLR code; verified data paths match. Losses: clip / sogclr / isogclr_new (+ cyclip, vicreg, onlineclr available). Optimizers: adamw (default), radam/nadam, momentum SGD. 

### Susan 19th November 2026

**Smoke test (friend's machine)**
- Hardware: NVIDIA RTX 4070 (12 GB), conda env `susan` (Python 3.10)
- Code: `iSogCLR/bimodal_exps/clip.py` (course codebase `csce689_iSogCLR`, branch `project`, unmodified)
- Data: subset built on Mac with `make_smoke.py` (278 MB)
  - 2,000 CC3M training pairs
  - 500 MSCOCO val pairs
  - ImageNet val: 1 image per class (1,000 classes)
- Settings: `--ita_type clip`, default optimizer AdamW, `--use_amp`, `--init_model`, tau 0.01, batch 128, 1 epoch

Training command:
```bash
python iSogCLR/bimodal_exps/clip.py --data_path ./datasets --ann_path ./clip_train --train_file cc3m_train_subset.json --train_image_root cc3m_subset_100k --output_dir output/smoke --init_model --use_amp --ita_type clip --tau_init 0.01 --eta_init 0.03 --sched cosine --no-distributed --epochs 1
```
Eval: same command + `--evaluate --checkpoint output/smoke/checkpoint_1.pth --zs_dataset imagenet --zs_datafolder ./datasets/imagenet/val`

**Results**
- Training ran end to end: loss 11.32 → 9.57 over 15 steps; checkpoint saved (`output/smoke/checkpoint_1.pth`)
- Peak GPU memory: 9.2 GB; batch 128 + AMP fits on 12 GB
- Speed: 0.89 s/step → ~11–12 min/epoch on 100k → ~6 h per 30-epoch run on a 4070
- COCO retrieval eval works (TR@1 0.2, IR@1 0.08; near zero as expected after 1 epoch on 2k pairs)
- ImageNet zero-shot eval: pending rerun

**To fix next time**
- Archives made on the Mac include hidden `._*` files that break ImageNet eval: build with `COPYFILE_DISABLE=1 tar cf ...`, or delete with `find datasets -name '._*' -delete`
- Validation metrics aren't logged during training; evaluate saved checkpoints separately and check which epochs get checkpointed before the 30-epoch runs

**Next**
- [ ] Rerun eval after deleting `._*` files; confirm ImageNet accuracy prints
- [ ] Check checkpoint-saving logic (every epoch vs. final only) for model selection
- [ ] Launch CLIP + AdamW 30-epoch baseline on lab GPU, then SogCLR + AdamW