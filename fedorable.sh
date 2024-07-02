#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
HEIGHT=20
WIDTH=90
CHOICE_HEIGHT=10
BACKTITLE="Fedorable - A Fedora Post Install Setup Util for GNOME - By Smittix - https://lsass.co.uk"
TITLE="Please Make a Selection"
MENU="Please Choose one of the following options:"

# Other variables
DNF_PACKAGES=$(cat dnf-packages.txt | grep --invert-match "#")
DNF_REMOVE_PACKAGES=$(cat dnf-remove-packages.txt | grep --invert-match "#")
LOG_FILE="setup_log.txt"

# Log function
log_action() {
    local message=$1
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" | tee -a $LOG_FILE
}

# Check for dialog installation
if ! rpm -q dialog &>/dev/null; then
    sudo dnf install -y dialog || { log_action "Failed to install dialog. Exiting."; exit 1; }
    log_action "Installed dialog."
fi


# Function to display notifications
notify() {
    local message=$1
    local expire_time=${2:-10}
    if command -v notify-send &>/dev/null; then
        notify-send "$message" --expire-time="$expire_time"
    fi
    log_action "$message"
}

OPTIONS=(
    1 "Enable RPM Fusion - Enables the RPM Fusion repos for your specific version"
    2 "Update Firmware - If your system supports FW update delivery"
    3 "Speed up DNF - Sets max parallel downloads to 10"
    4 "Enable Flatpak - Enables the Flatpak repo and installs packages located in flatpak-packages.txt"
    5 "Install Software - Installs software located in dnf-packages.txt"
    6 "Install Oh-My-Posh - Installs Zsh & Oh-My-Posh"
    7 "Install Extras - Themes, Fonts, and Codecs"
    8 "Install Nvidia - Install akmod Nvidia drivers"
    9 "Remove Software - Removes libre office and packages specified in dnf-remove-packages.txt"
    10 "Install XBOX - Install XBOX drivers for wireless Controller with dongle"
    11 "Configure Git - Setting username and email"
    12 "Quit"
)

# Main loop
while true; do
    CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --nocancel \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

    clear
    case $CHOICE in
        1)
            echo "Enabling RPM Fusion"
            sudo dnf install -y \
                https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
                https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
            sudo dnf upgrade --refresh -y
            sudo dnf groupupdate -y core
            sudo dnf install -y rpmfusion-free-release-tainted dnf-plugins-core
            notify "RPM Fusion Enabled"
            ;;
        2)
            echo "Updating System Firmware"
            sudo fwupdmgr get-devices
            sudo fwupdmgr refresh --force
            sudo fwupdmgr get-updates
            sudo fwupdmgr update
            notify "System Firmware Updated"
            ;;
        3)
            echo "Speeding Up DNF"
            echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
            notify "Your DNF config has now been amended"
            ;;
        4)
            echo "Enabling Flatpak"
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            flatpak update -y
            if [ -f flatpak-install.sh ]; then
                source flatpak-install.sh
            else
                log_action "flatpak-install.sh not found"
            fi
            notify "Flatpak has now been enabled"
            ;;
        5)
            echo "Installing Software"
            sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
            if [ -f dnf-packages.txt ]; then
                sudo dnf install -y "$DNF_PACKAGES"
                notify "Software has been installed"
            else
                log_action "dnf-packages.txt not found"
            fi
            notify "Software has been installed"
            ;;
        6)
            echo "Installing Oh-My-Posh"
            mkdir $HOME/.config/omp
            cp omp_theme.toml $HOME/.config/omp/omp_theme.toml
            sudo dnf install -y zsh curl util-linux-user
            chsh -s "$which zsh"
            autoload -Uz zsh-newuser-install
            zsh-newuser-install -f
            curl -s https://ohmyposh.dev/install.sh | sudo bash -s
            echo 'eval "$(oh-my-posh init zsh --config $HOME/.config/omp/omp_theme.toml)"' >> ~/.zshrc
            oh-my-posh font install meslo
            notify "Oh-My-Posh is ready to rock n roll"
            ;;
        7)
            echo "Installing Extras"
            sudo dnf groupupdate -y sound-and-video
            sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing
            sudo dnf install -y libdvdcss
            sudo dnf install -y gstreamer1-plugins-{bad-\*,good-\*,ugly-\*,base} gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel ffmpeg gstreamer-ffmpeg
            sudo dnf install -y lame\* --exclude=lame-devel
            sudo dnf group upgrade -y --with-optional Multimedia
            sudo dnf config-manager --set-enabled fedora-cisco-openh264
            sudo dnf install -y gstreamer1-plugin-openh264 mozilla-openh264
            sudo dnf copr enable peterwu/iosevka -y
            sudo dnf update -y
            sudo dnf install -y iosevka-term-fonts jetbrains-mono-fonts-all terminus-fonts terminus-fonts-console google-noto-fonts-common fira-code-fonts cabextract xorg-x11-font-utils fontconfig
            sudo rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
            notify "Extras has been installed"
            ;;
        8)
            echo "Installing Nvidia Driver Akmod-Nvidia"
            sudo dnf install -y akmod-nvidia
            notify "Please wait 5 minutes until rebooting"
            ;;
        9)
            echo "Removing Software"
            sudo dnf group remove libreoffice
            sudo dnf remove libreoffice-core
            if [ -f dnf-remove-packages.txt ]; then
                sudo dnf remove -y "$DNF_REMOVE_PACKAGES"
                notify "Software has been installed"
            else
                log_action "dnf-remove-packages.txt not found"
            fi
            notify "Software has been removed"
            ;;
        10)
            echo "Installing XBOX drivers for wireless Controller with dongle"
            sudo dnf install -y dkms cabextract git-core
            cd ~/Downloads
            git clone https://github.com/medusalix/xone
            cd xone
            sudo ./install.sh
            sudo xone-get-firmware.sh
            cd ..
            rm -rf xone
            notify "XBOX Dongle drivers installed"
            ;;
        11)
            echo "Setting up git"
            sudo dnf install -y git-core
            echo "Please enter user.name"
            read username
            echo "Please enter user.email"
            read email
            git config --global user.name "$username"
            git config --global user.email "$email"
            notify "Git is ready to go"
            ;;
        12) log_action "User chose to quit the script."; exit 0 ;;
        *) log_action "Invalid option selected: $CHOICE";;
    esac
done

