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