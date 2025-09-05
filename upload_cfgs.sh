#!/bin/zsh
# Usage: ./upload_cfgs.sh
# Copies all .cfg and .conf files except those containing 'example' in the filename using rsync

target="linaro@192.168.50.97:/home/linaro/printer_data/config/"

# Use rsync to copy all .cfg files except those containing 'example' in the filename
rsync -avz --exclude '*example*' config/*.cfg "$target"

# Additionally, copy all .conf files except those containing 'example' in the filename
rsync -avz --exclude '*example*' config/*.conf "$target"