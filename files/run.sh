#!/usr/bin/env bash
set -x

exec python /application/image-manager.py --cloud $IMAGE_MANAGER_CLOUD --imagefile $IMAGE_MANAGER_IMAGEFILE --tmppath /data $IMAGE_MANAGER_ACTION
