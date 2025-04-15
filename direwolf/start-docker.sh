#!/bin/bash

cd "$(dirname "$0")"

VERSION="latest"
if [[ -f VERSION ]] ; then
    VERSION="$(cat VERSION)"
fi

# system memory used to scale Java VM memory.
# Defaults to 8GB if auto-detection fails.
system_ram_kb="$((8 * 1024 * 1025))"
grok_ram_kb="$(sed -n 's/MemTotal:[[:space:]]*\([0-9]\+\) .*/\1/p' /proc/meminfo)"
if [[ $grok_ram_kb =~ '^[0-9]+$' ]] ; then
    system_ram_kb="$grok_ram_kb"
fi

# clean up old containers
docker container rm --force  direwolf-server 2>/dev/null

xms="$((system_ram_kb * 2 / 3))"
xmx="$((system_ram_kb * 9 / 10))"

user="$(id -u)"
group="$(id -g)" 

mkdir -p data

set -x
exec docker run -i --name direwolf-server \
                -p 25565:25565 \
                -p 25575:25575 \
                --user "$user":"$group" \
                -v $(pwd)/data:/minecraft-server-data/ \
                --env USER_JVM_ARGS="-Xms${xms}k -Xmx${xmx}k" \
                direwolf:"$VERSION" \
                    ./run.sh
