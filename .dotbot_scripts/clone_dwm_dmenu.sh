#!/bin/sh

git clone https://git.suckless.org/dmenu ~/.local/src/dmenu
rm ~/.local/src/dmenu/config.mk

git clone https://git.suckless.org/dwm ~/.local/src/dwm
rm ~/.local/src/dwm/config.mk
# TODO apply patches

git clone https://github.com/UtkarshVerma/dwmblocks-async.git ~/.local/src/dwmblocks-async
rm ~/.local/src/dwmblocks-async/config.mk
rm ~/.local/src/dwmblocks-async/Makefile
