#!/bin/bash

HOST="$(hostname)"  # Or use custom value if preferred

# 1. Check for pamu2fcfg, prompt install if missing.
if ! command -v pamu2fcfg > /dev/null 2>&1; then
    # Detect distribution
    OS=""
    if grep -q "Ubuntu" /etc/os-release; then
        OS="Ubuntu"
    elif grep -q "Arch" /etc/os-release || [ -f /etc/arch-release ]; then
        OS="Arch"
    fi
    echo "pamu2fcfg command not found!"
    if [ "$OS" = "Ubuntu" ]; then
        echo "Run: sudo apt update && sudo apt install libpam-u2f"
    elif [ "$OS" = "Arch" ]; then
        echo "Run: sudo pacman -Sy pam-u2f"
    else
        echo "Please install pamu2fcfg."
    fi
    exit 1
fi

# 2. Prepare config folder
mkdir -p ~/.config/Yubico

# 3. Register key or append
U2F_FILE="$HOME/.config/Yubico/u2f_keys"
if [ ! -f "$U2F_FILE" ]; then
    echo "Registering first U2F key for ${HOST} ..."
    pamu2fcfg -o pam://"${HOST}" -i pam://"${HOST}" > "$U2F_FILE"
else
    echo "Appending new U2F key for ${HOST} ..."
    pamu2fcfg -o pam://"${HOST}" -i pam://"${HOST}" -n >> "$U2F_FILE"
fi

echo "U2F key registration completed."

# 5a. /etc/pam.d/sudo suggestion
echo "----------------------------------------------------"
SUDO_CFG_LINE="auth sufficient pam_u2f.so cue " \
    "origin=pam://${HOST} appid=pam://${HOST}"
SUDO_FILE="/etc/pam.d/sudo"

if [ ! -f "$SUDO_FILE" ]; then
    echo "SUDO PAM file $SUDO_FILE not found, skipping."
else
    if ! grep -Fq "$SUDO_CFG_LINE" $SUDO_FILE; then
        echo "Line not found in $SUDO_FILE:"
        echo "$SUDO_CFG_LINE"
        read -p -r "Insert at the top of the file? [Y/n]: " answer
        case "$answer" in
            [Yy]*|"")
                # Insert line at the top using sudo (preserves comments at the start)
                sudo sed -i "1i$SUDO_CFG_LINE" $SUDO_FILE
                echo "Configuration added."
                ;;
            [Nn]*)
                echo "Skipped modification."
                ;;
            *)
                echo "Invalid response, skipped modification."
                ;;
        esac
    else
        echo "Configuration already present in /etc/pam.d/sudo."
    fi
fi

# 5b. /etc/pam.d/gdm-password suggestion
echo "----------------------------------------------------"
GDM_CFG_LINE="auth required pam_u2f.so nouserok " \
    "origin=pam://${HOST} appid=pam://${HOST}"
GDM_FILE="/etc/pam.d/gdm-password"

if [ ! -f "$GDM_FILE" ]; then
    echo "GDM PAM file $GDM_FILE not found, skipping."
else
    if ! grep -Fq "${GDM_CFG_LINE}" "${GDM_FILE}"; then
        echo "GDM line not found in $GDM_FILE:"
        echo "$GDM_CFG_LINE"
        read -p -r "Append after last 'auth' line? [Y/n]: " answer
        case "$answer" in
            [Yy]*|"")
                # Find last 'auth' line number and insert after
                LINE_NO=$(grep -n "^auth" "$GDM_FILE" | tail -1 | cut -d: -f1)
                sudo sed -i "${LINE_NO}a$GDM_CFG_LINE" "$GDM_FILE"
                echo "Configuration added for GDM."
                ;;
            [Nn]*)
                echo "Skipped modification for GDM."
                ;;
            *)
                echo "Invalid response, skipped modification."
                ;;
        esac
    else
        echo "GDM configuration already present."
    fi
fi

# 5c. /etc/pam.d/kde-fingerprint suggestion
echo "----------------------------------------------------"
KDE_LINE="auth required pam_u2f.so cue pinverification=0 userverification=1"
KDE_FILE="/etc/pam.d/kde-fingerprint"

if [ ! -f "$KDE_FILE" ]; then
    echo "KDE fingerprint PAM file $KDE_FILE not found, skipping."
else
    if ! grep -Fq "$KDE_LINE" "$KDE_FILE"; then
        echo "KDE U2F line not found in $KDE_FILE:"
        echo "$KDE_LINE"
        read -p -r "Comment out pam_fprintd.so and add U2F line? [Y/n]: " answer
        case "$answer" in
            [Yy]*|"")
                # Comment out pam_fprintd.so (if not yet commented)
                sudo sed -i '/pam_fprintd\.so/ s/^/#/' "$KDE_FILE"
                # Insert new line after (customize placement if needed)
                sudo sed -i "/pam_fprintd\.so/a$KDE_LINE" "$KDE_FILE"
                echo "Configuration added for KDE fingerprint."
                ;;
            [Nn]*)
                echo "Skipped modification for KDE fingerprint."
                ;;
            *)
                echo "Invalid response, skipped modification."
                ;;
        esac
    else
        echo "KDE fingerprint configuration already present."
    fi
fi

echo "----------------------------------------------------"
