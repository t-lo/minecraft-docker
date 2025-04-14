#!/bin/sh

# These three are interdependent.
# See https://www.feed-the-beast.com/modpacks?search=direwolf&sort=release
# for new releases.

# Minecraft 1.21.1
#pack=126
#version=100062
#release="minecraft-1.21.1-neoforge-21.1.145-direwolf-1.12.0"

# Minecraft 1.20.1
pack=119
version=100051
release="minecraft-1.20.1-forge-47.1.84-direwolf-1.16.1"

docker build --build-arg pack_id="${pack}" \
             --build-arg version_id="${version}" -t direwolf:${release} .

echo "${release}" > VERSION
