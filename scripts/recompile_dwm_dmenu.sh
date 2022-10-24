#!/bin/sh

tmp_dir=$(pwd)

echo " >>>>>>>>>> Recompiling dwmblocks-async..."
cd $HOME/.local/src/dwmblocks-async
make clean install

echo " >>>>>>>>>> Recompiling dwm..."
cd $HOME/.local/src/dwm
make clean install

echo " >>>>>>>>>> Recompiling dmenu..."
cd $HOME/.local/src/dmenu
make clean install

echo "Done"
cd $tmp_dir
