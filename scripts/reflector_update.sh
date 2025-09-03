#!/bin/bash
# Very long command to update arch linux pacman repositories

sudo reflector --latest 100 --sort rate --save /etc/pacman.d/mirrorlist --protocol https --threads $(nproc --all)

# You can always store config in
# /etc/xdg/reflector/reflector.conf
# and automate it with
# systemctl enable reflector.timer
# systemctl start reflector.timer
