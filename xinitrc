# TODO configure lightweight alternative for redshift

# TODO setup autorandr
xrandr --output HDMI-1 --mode 1920x1080 --rotate right --left-of DP-1 \
--output HDMI-0 --mode 1920x1080 --right-of DP-1 \
--output DP-1 --mode 2560x1440

# TODO create folder with wallpapers
feh --bg-fill ~/images/nier_automata_menu_lines.png

xset +fp ~/.local/share/fonts

export PATH=~/local/bin/statusbar:$PATH
dwmblocks &
exec dwm
