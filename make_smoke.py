import json, os, shutil

OUT = "smoke_data"
N_TRAIN, N_COCO = 2000, 500

def copy(src, dst):
    os.makedirs(os.path.dirname(dst), exist_ok=True)
    shutil.copy2(src, dst)

os.makedirs(f"{OUT}/clip_train", exist_ok=True)

train = json.load(open("clip_train/cc3m_train_subset.json"))[:N_TRAIN]
for e in train:
    copy(f"datasets/cc3m_subset_100k/{e['image']}", f"{OUT}/datasets/cc3m_subset_100k/{e['image']}")
json.dump(train, open(f"{OUT}/clip_train/cc3m_train_subset.json", "w"))
print("train images:", len(train))

coco = json.load(open("clip_train/coco_val.json"))[:N_COCO]
index = {}
for root, _, files in os.walk("datasets/mscoco_val"):
    for f in files:
        index[f] = os.path.join(root, f)
missing = 0
for e in coco:
    src = index.get(e["image"])
    if src is None:
        missing += 1
        continue
    copy(src, f"{OUT}/{src}")
json.dump(coco, open(f"{OUT}/clip_train/coco_val.json", "w"))
print("coco images:", len(coco) - missing, "missing:", missing)

val = "datasets/imagenet/val"
n_classes = 0
for name in sorted(os.listdir(val)):
    p = os.path.join(val, name)
    if os.path.isdir(p):
        imgs = sorted(os.listdir(p))
        if imgs:
            copy(os.path.join(p, imgs[0]), f"{OUT}/{p}/{imgs[0]}")
            n_classes += 1
    else:
        copy(p, f"{OUT}/{p}")
print("imagenet classes:", n_classes)

print("done")