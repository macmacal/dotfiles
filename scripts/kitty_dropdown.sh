#!/bin/bash

LAST_MONITOR=""

# Detect session type
if [ "$XDG_SESSION_TYPE" == "x11" ]; then
    SESSION="X11"
elif [ "$XDG_SESSION_TYPE" == "wayland" ]; then
    # Check if Mutter is your compositor
    if pgrep -x "mutter" > /dev/null; then
        SESSION="MUTTER"
    else
        SESSION="WAYLAND"
    fi
else
    SESSION="UNKNOWN"
fi

# X11 logic: get monitor from focused window
if [ "$SESSION" == "X11" ]; then
    WIN_ID=$(xdotool getwindowfocus)
    # Get window geometry (position)
    WIN_GEOM=($(xdotool getwindowgeometry "$WIN_ID" | awk '/Position:/ {split($2,a,","); print a[1],a[2]}'))
    WIN_X=${WIN_GEOM[0]}
    WIN_Y=${WIN_GEOM[1]}
    # List outputs and their geometry
    while read name x y w h; do
        if (( WIN_X >= x && WIN_X < x + w && WIN_Y >= y && WIN_Y < y + h )); then
            LAST_MONITOR="$name"
            break
        fi
    done < <(xrandr --listmonitors | awk 'NR>1{print $4,$2,$3,$5,$6}' | tr -d '+')
fi

# MUTTER/GNOME/WAYLAND logic (fallback to dbus for GNOME Shell 3.15+)
if [ "$SESSION" == "MUTTER" ] || [ "$SESSION" == "WAYLAND" ]; then
    # Try to get the name of the focused window's output (requires gdbus and GNOME)
    ACTIVE_APP=$(gdbus call -e -d org.gnome.Shell -o /org/gnome/Shell -m org.gnome.Shell.Eval "global.get_window_actors().findIndex(a=>a.meta_window.has_focus())")
    if [ -n "$ACTIVE_APP" ]; then
        ACTIVE_OUTPUT=$(gdbus call -e -d org.gnome.Shell -o /org/gnome/Shell -m org.gnome.Shell.Eval "global.get_window_actors()[$ACTIVE_APP].get_meta_window().get_monitor().get_name()")
        LAST_MONITOR="$ACTIVE_OUTPUT"
    fi
fi

export LAST_MONITOR
echo "LAST_MONITOR=$LAST_MONITOR"
echo "SESSION=$SESSION"

kitten quick-access-terminal --detach
