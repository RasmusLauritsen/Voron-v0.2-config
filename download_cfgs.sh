#!/bin/zsh
# Usage: ./download_cfgs.sh
# Copies all .cfg and .conf files except those containing 'example' in the filename using rsync

source="linaro@voron-02-pro.local:/home/linaro/printer_data/config/"
target=".current_config/"

mkdir -p "$target"

# Use rsync to copy all .cfg files except those containing 'example' in the filename
rsync -avz --exclude '*example*' "${source}*.cfg" "$target"

# Additionally, copy all .conf files except those containing 'example' in the filename
rsync -avz --exclude '*example*' "${source}*.conf" "$target"
