#!/bin/zsh
# Usage: ./upload_cfgs.sh
# Copies all .cfg and .conf files recursively except those containing 'example' in the filename using rsync

target="linaro@voron-02-pro.local:/home/linaro/printer_data/config/"

rsync -avz \
  --include '*/' \
  --include '*.cfg' \
  --include '*.conf' \
  --exclude '*example*' \
  --exclude '*' \
  config/ "$target"
