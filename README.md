<h1 align="center">
  Fedorable - a post install helper script (thx smittix).
</h1>

## What's all this then?
Fedora-Setup is a personal script I created to help with post install tasks such as tweaks and software installs. It's written in Bash and utilises Dialog for a friendlier menu system.

Dialog must be installed for the menu system to work and as such the script will check to see if Dialog is installed. If not, it will ask you to install it.

## Notices
- Export oh my posh theme with `oh-my-posh config export --output ./path.toml`
- Customization
	- Theme Lisa
	- Window decoration edit `Button size - Large`
	- Icons Tela purple light
	- No sounds
	- No Splashscreen
	- Terminal Setting: Profil, Solarized - Transparenz: 20%, Font Meslo Nerd Font
- Have an eye on https://github.com/emvaized/kde-snap-assist
- Geany save action Plugin, see Pr: https://github.com/geany/geany/pull/3911
- Vivaldi flickering fix
	- type in address bar `vivaldi://flags`
	- search for `Ozone` - Preferred Ozone platform
	- Switch to Auto
- If there is a second rive mounted in mnt/drive_name
	- Go to Flatseal and enable Filesystem access to the mount point
		- Filesystem > Other files > All system files
	- Same for Signal user files

## Usage
1. Set the script to be executable `chmod +x fedorable.sh`
2. Run the script `./fedorable.sh`
3. Enter user password when required (for installation of packages)

## Files
- **flatpak-packages.txt** - This file contains a list of all flat packages to install you can customise this with your choice of applications by application-id.
- **dnf-packages.txt** - This file contains a list of all applications that will be installed via the Fedora and RPMFusion repositories.
- **dnf-remove-packages.txt** - This file contains a list of all applications that will be removed via the Fedora and RPMFusion repositories.

# Options
- ## Enable RPM Fusion
  - Enables RPM Fusion repositories using the official method from the RPM Fusion website. - [RPM Fusion](https://rpmfusion.org)
  > RPM Fusion provides software that the Fedora Project or Red Hat doesn't want to ship. That software is provided as precompiled RPMs for all current Fedora versions and current Red Hat Enterprise Linux or clones versions; you can use the RPM Fusion repositories with tools like yum and PackageKit.
- ## Update Firmware
  - **Updates firmware providing you have hardware that supports it.**
- ## Speed up DNF
  - **Sets max parallel downloads to 10**
- ## Enable Flatpak and Packages
  ### Adds the flatpak repo, updates and installs the packages specified in flatpak-packages.txt
- ## Install Software
  ### Installs the following pieces of software specify in dnf-packages.txt
- ## Install Oh-My-Posh
- ## Install Extras
  ### Installs the following fonts
    - **iosevka-term-fonts** - [Iosevka Font](https://github.com/be5invis/Iosevka)
    - **jetbrains-mono-fonts-all** - [JetBrains Font](https://www.jetbrains.com/lp/mono/)
    - **terminus-fonts** - [Terminus Font](https://terminus-font.sourceforge.net/)
    - **terminus-fonts-console** - [Terminus Font](https://terminus-font.sourceforge.net/)
    - **google-noto-fonts-common** - [Google Noto Sans Font](https://fonts.google.com/noto/specimen/Noto+Sans)
    - **MScore fonts** - [ore fonts for the Web was a project started by Microsoft in 1996 to create a standard pack of fonts for the World Wide Web](https://mscorefonts2.sourceforge.net/)
    - **fira-code-fonts** - [Google Fira Code Font](https://fonts.google.com/specimen/Fira+Code)
  ### Installs the following extras
    - **Sound and video group**
    - **libdvdcss** - [libdvdcss is a simple library designed for accessing DVDs](https://videolan.videolan.me/libdvdcss/)
    - **gstreamer plugins** - [a framework for streaming media](https://github.com/GStreamer/gstreamer)
  ### Install Nvidia
    - **Installs the akmod-nvidia driver from the RPMFusion repo's** - [An akmod is a type of package similar to dkms. As you start your computer, the akmod system will check if there are any missing kmods and if so, rebuild a new kmod for you. Akmods have more overhead than regular kmod packages as they require a few development tools such as gcc and automake in order to be able to build new kmods locally](https://rpmfusion.org/Howto/NVIDIA#Akmods)
- ## Remove Software
  ### Removes libre office and packages specified in dnf-remove-packages.txt
- ## Install XBOX
  ### Install XBOX drivers for wireless Controller with dongle
- ## Configure Git
  ## Prompt to enter git username and email
