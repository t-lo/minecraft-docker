#!/bin/bash

# clean up old containers
docker container rm --force  pixelmon-9.0.2 2>/dev/null

exec docker run -it --name pixelmon-9.0.2 \
                -p 25565:25565 \
                -v $(pwd)/world:/minecraft-server/world \
                -v $(pwd)/server.properties:/minecraft-server/server.properties \
                pixelmon:9.0.2
