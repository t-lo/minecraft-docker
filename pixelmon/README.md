# Minecraft Pixelmon mod

Uses
* Minecraft version 1.16.5
* Forge version 36.2.34
* Pixelmon version 9.0.2

## Build the docker image

This will create the docker image on your server.
Only required once.

```shell
cd build
docker build -t pixelmon:9.0.2 .
```

## Create a container and run it

The script will start a minecraft / forge / pixelmon server on default port 25565.
Edit `pixelmon.sh` to change the container/host port mapping if you want a different port.

```shell
./pixelmon.sh
```
