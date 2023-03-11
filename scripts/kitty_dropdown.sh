#!/usr/bin/bash
# AUTHOR: gotbletu (@gmail|twitter|youtube|github|lbry)
#         https://www.youtube.com/user/gotbletu
# DESC:   turn any terminal into a dropdown terminal
# DEMO:   https://www.youtube.com/watch?v=mVw2gD9iiOg
# DEPEND: coreutils xdotool wmutils (https://github.com/wmutils/core | https://aur.archlinux.org/packages/wmutils-git/)
# CLOG:   2022-03-05   else statement to allow terminal to jump to current virtual desktop if is visible on another desktop 
#         2022-02-28   added auto launch terminal if none running by https://github.com/aaccioly
#         2021-02-10   use comm to match window name and class, this avoids terminal windows with different names
#         2015-02-15   0.1
 
# get screen resolution width and height
ROOT=$(lsw -r)
#width=$(wattr w "$ROOT")
#height=$(wattr h "$ROOT")
#width=1920
#height=1080
 
# option 1: set terminal emulator manually
my_term="kitty"
 
# option 2: auto detect terminal emulator (note: make sure to only open one)
# my_term="urxvt|kitty|xterm|uxterm|termite|sakura|lxterminal|terminator|mate-terminal|pantheon-terminal|konsole|gnome-terminal|xfce4-terminal"
 
# get terminal emulator pid ex: 44040485
# pid=$(xdotool search --class "$my_term" | tail -n1)
 
# get terminal emulator and matching name pid ex: 44040485 
#pid=$(comm -12 <(xdotool search --name "$my_term" | sort) <(xdotool search --class "$my_term" | sort))
#pid=$(pidof "$my_term")
pid=$(comm -12 <(xdotool search --pid $(pidof $my_term -S $'\n' | sort | head -n 1)) <(xdotool search --class "$my_term" | sort | head -n 1))

echo "Hello there mr. $pid"
# start a new terminal if none is currently running
if [[ -z "$pid" ]]; then
    echo "NO TERMINAL?"
    while IFS='|' read -ra TERMS; do
        for candidate_term in "${TERMS[@]}"; do
            if command -v "$candidate_term" &>/dev/null; then
                ${candidate_term} &>/dev/null &
                disown
                pid=$!
                break
            fi
        done
    done <<<"$my_term"
  else
    echo "TERMINAL DETECTED"
    # get windows id from pid ex: 0x2a00125%
    wid=$(printf '0x%x' $pid)
    # maximize terminal emulator
    #wrs "$width" "$height" "$wid"
    # toggle show/hide terminal emulator
    mapw -t $wid
fi
