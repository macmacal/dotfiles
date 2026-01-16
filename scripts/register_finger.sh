#!/bin/bash

# Define a map of selections to their corresponding fprintd finger names
declare -A finger_map=(
    ["R Thumb"]="right-thumb"
    ["R Index"]="right-index-finger"
    ["R Middle"]="right-middle-finger"
    ["R Ring"]="right-ring-finger"
    ["R Little"]="right-little-finger"
    ["L Thumb"]="left-thumb"
    ["L Index"]="left-index-finger"
    ["L Middle"]="left-middle-finger"
    ["L Ring"]="left-ring-finger"
    ["L Little"]="left-little-finger"
)

# Display the options for selection using gum
selection=$(
    gum choose --no-limit \
        "${!finger_map[@]}"
)

# Convert the multi-line selection into an array
IFS=$'\n' read -rd '' -a selected_fingers <<<"$selection"

# Loop through the selected options and enroll each finger
for finger in "${selected_fingers[@]}"; do
    fprintd-enroll -f "${finger_map[$finger]}"
done
