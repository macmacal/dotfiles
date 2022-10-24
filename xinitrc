# TODO configure lightweight alternative for redshift

autorandr --change

# TODO create scripts for automatic wallpaper rotation
#feh --recursive --bg-fill --randomize ~/images/wallpapers/*
feh --bg-fill ~/images/wallpapers/yorha_wallpaper.jpg ~/images/wallpapers/yorha_wallpaper.jpg 

xset +fp ~/.local/share/fonts

export PATH=~/local/bin/statusbar:$PATH
dwmblocks &
exec dwm
