# Minecraft server and FTB Direwolf mod pack container

Automation in this directory produces and runs a Minecraft server container
that ships the FTB Direwolf mod pack (including Neoforge, the mod loader).

See https://www.feed-the-beast.com/modpacks/126-ftb-presents-direwolf20-121
for more information.

Clients will need Neoforge and the Direwolf mods installed.
The Neoforge installer can be acquired from here: https://neoforged.net/

The mods can be installed either via the FTB Direwolf installer or extracted
from running the container locally via `start-docker.sh`, which will copy all
mods to the `data/mods` sub-directory.

## Building

Run
```bash
./build.sh
```
See variables in `build.sh` for the Minecraft and Direwolf versions being built.

## Running

Run
```bash
./start-docker.sh
```
This will initialise a local `data/` sub-directory containing all state.
The directory should be included in your server back-ups.

The script will attach to the server's command line interface.

To stop the server, type
```
stop
```

## Systemd service

A complementary `direwolf-server.service` systemd service unit is included.
It expects the dorewolf server to be installed in `/opt/direwolf-server`.
