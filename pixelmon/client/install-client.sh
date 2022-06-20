#!/usr/bin/bash

function banner() {
    local num="$(echo "$@" | wc -c)"
    printf "##%${num}s##\n" | tr ' ' '#'
    echo "# $@ #"
    printf "##%${num}s##\n" | tr ' ' '#'
}


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

launcher_bin="$HOME/.minecraft/launcher/minecraft-launcher"

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

cd $HOME/Downloads
if [ ! -f "$HOME/Downloads/forge-1.16.5-36.2.34-installer.jar" ] ; then
    wget -O "$HOME/Downloads/forge-1.16.5-36.2.34-installer.jar" \
        https://maven.minecraftforge.net/net/minecraftforge/forge/1.16.5-36.2.34/forge-1.16.5-36.2.34-installer.jar
fi

java -jar "$HOME/Downloads/forge-1.16.5-36.2.34-installer.jar"


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


cd "$HOME/.minecraft/mods"
wget https://download.nodecdn.net/containers/reforged/universal/release/Pixelmon-1.16.5-9.0.2-universal.jar

banner "All done - enjoy Pixelmon!"

echo
echo " Run '$HOME/.minecraft/launcher/minecraft-launcher' to start."
