#!/bin/bash

cd "$(dirname "$0")"

# clean up old containers
docker container rm --force  minecraft-raspberryjuice 2>/dev/null

exec docker run --rm -i --name minecraft-raspberryjuice \
                -p 25565:25565 \
                -p 127.0.0.1:4711:4711 \
                -v $(pwd)/world:/raspberryjuice/world \
                -v $(pwd)/world_nether:/raspberryjuice/world_nether \
                -v $(pwd)/world_the_end:/raspberryjuice/world_the_end \
                -v $(pwd)/server.properties:/raspberryjuice/server.properties \
                minecraft-raspberryjuice:1.18.1
