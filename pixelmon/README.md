# Dockerised minecraft pixelmon mod

Uses
* Minecraft version 1.16.5
* Forge version 36.2.34
* Pixelmon version 9.0.2

## Client

There's an installer script at `client/install-client.sh` which guides through local set-up of the minecraft pixelmon client.

## Server

Included is a `Dockerfile` for building the image from scratch as well as wrapper scripts for running it.
The wrapper scripts use volume mounts from their respective local directory for world data and configuration for convenient backup.

You don't actually need a server if you only want to play locally (including local multiplayer).
It's handy though if you want to play over the internet from multiple locations.
It's also nice for backing up and for restoring worlds.

### Start the server

If you have a container image available (see below) just run the `pixelmon.sh` wrapper script.

The script will start a minecraft / forge / pixelmon server on default port 25565.
Edit `pixelmon.sh` to change the container/host port mapping if you want a different port.

```shell
cd server/run
./pixelmon-server.sh
```

There's a systemd unit file `minecraft-pixelmon.service` which lets you start the server automatically.
To activate, run as `root`:

```shell
mkdir -p /opt/pixelmon-server
cp -r server/run/* /opt/pixelmon-server/
mv /opt/pixelmon-server/pixelmon-server.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable --now pixelmon-server.service
```

### Build the docker image

This will create the docker image on your server.
Only required once.

```shell
cd server/build
docker build -t pixelmon-server:9.0.2 .
```
