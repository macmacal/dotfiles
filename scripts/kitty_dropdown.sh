#!/usr/bin/bash
# AUTHOR: macmacal, based on orignal script by gotbletu 
# DESC:   turn kitty terminal (xwindow) into a dropdown terminal
# DEPEND: coreutils xdotool wmutils 
 
# get screen resolution width and height
ROOT=$(lsw -r)
width=1920
height=1080
 
# select terminal emulator manually
my_term=kitty
 
# get terminal emulator and matching name pid ex: 44040485 
term_pid=$(pidof -S $'\n' $my_term | tail -n1)

# check if the emulator window exists
window_id=$(comm -12 <(xdotool search --pid $term_pid) <(xdotool search --class $my_term | sort))

# start a new terminal if none is currently running
if [[ -z $window_id ]]; then
    ${my_term} &>/dev/null &
  else
    # get windows id from pid ex: 0x2a00125%
    wid=$(printf '0x%x' $window_id)
    # toggle show/hide terminal emulator
    mapw -t $wid
    # maximize terminal emulator
    #wrs $width $height $wid
fi
