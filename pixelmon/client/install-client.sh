#!/usr/bin/bash

function banner() {
    local num="$(echo "$@" | wc -c)"
    printf "##%${num}s##\n" | tr ' ' '#'
    echo "# $@ #"
    printf "##%${num}s##\n" | tr ' ' '#'
}

launcher_bin="$HOME/.minecraft/launcher/minecraft-launcher"
forge_url="https://maven.minecraftforge.net/net/minecraftforge/forge/1.16.5-36.2.34/forge-1.16.5-36.2.34-installer.jar"
forge_download_dest"$HOME/Downloads/forge-1.16.5-36.2.34-installer.jar"
forge_install_check_dest="$HOME/.minecraft/versions/1.16.5-forge-36.2.34/1.16.5-forge-36.2.34.jar"

pixelmon_url="https://download.nodecdn.net/containers/reforged/universal/release/Pixelmon-1.16.5-9.0.2-universal.jar"
pixelmon_install_dest="$HOME/.minecraft/mods/Pixelmon-1.16.5-9.0.2-universal.jar"


banner "Minecraft pixelmon client first-run setup"
echo
echo "This installer will guide you through the following steps:"
echo "  1. Ensure prerequisites are met."
echo "  2. Install the forge plug-in required by pixelmon."
echo "  3. Set up the forge plug-in required by pixelmon."
echo "  4. Install the Pixelmon mod."
echo
echo "Changes will happen in the local '$HOME/.minecraft' directory."
echo "Downloads (Forge installer JAR) will be stored in"
echo " '$HOME/Downloads'."
echo
echo "Press <return> to continue."
read JUNK

banner " Step 1: Checking for prerequisites."
echo
echo "We'll check for the correct Java version (java 8) and"
echo "   for the minecraft launcher to be present."
echo
echo "Press <return> to continue."
read JUNK

echo "Checking for Java version 1.8."
if ! java -version 2>&1 | grep 'build 1.8.0' ; then
    echo
    echo " Java version 1.8 not found or not set up as default."
    echo " Please install openjdk-8-jre (or the equvalent for your distro)"
    echo "   and use 'update-alternatives --config java' to set up version 1.8"
    echo "   as the default."
    echo
    exit
fi

if [ ! -x "$launcher_bin" ] ; then
    echo
    echo "Minecraft launcher is missing."
    echo " ('$launcher_bin' missing or not executable)"
    echo
    echo "Download the launcher from https://www.minecraft.net/en-us/download"
    echo " and run it to create $HOME/.minecraft/... ."
    echo
    exit
fi

echo
echo "All good. Continuing."
echo

banner " Step 2: Install the Forge plug-in."
echo
echo " In this step we'll download the forge installer and run it."
echo " Forge's installation GUI will launch; please click 'OK' to install"
echo "    the client to the default location ($HOME/.minecraft)."
echo " After successful installation the installer will quit automatically."
echo
echo "Press <return> to continue."
read JUNK

if [ -f "$forge_install_check_dest" ] ; then
    echo "Forge already installed, skipping step 3. and continuing to step 4."
    echo
else
    if [ ! -f "$forge_download_dest" ] ; then
        wget -O "$forge_download_dest" "$forge_url"
    else
        echo "Forge jar found at '$forge_download_dest', using that."
    fi
    java -jar "$forge_download_dest"

    banner "Step 3: Set up Forge"
    echo
    echo " In order for Forge to initialise, it must be started"
    echo "   from the minecraft launcher. We'll start the launcher for this."
    echo " In the launcher, log in, then make sure 'Forge' is selected, and hit 'play'."
    echo " Quit the game (and the launcher) from the main Minecraft screen to continue."
    echo
    echo "Press <return> to continue."
    read JUNK

    $launcher_bin
fi

banner "Step 4: Install the pixelmon mod."
echo
echo " This will download the mod JAR to"
echo " '$HOME/.minecraft/mods'."
echo " After the download concluded this script will terminate."
echo " Just start minecraft from the launcher and select 'Forge' to enjoy"
echo " Pixelmon."
echo
echo "Press <return> to continue."
read JUNK


if [ -f "$pixelmon_install_dest" ] ; then
    echo "Pixelmon already installed, skipping step 4."
    echo
else
    wget -O "$pixelmon_install_dest" "$pixelmon_url"
fi

banner "All done - enjoy Pixelmon!"

echo
echo " Run '$HOME/.minecraft/launcher/minecraft-launcher' to start."
echo
