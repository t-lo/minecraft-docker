# Dockerised minecraft Python API (via Spigot / RaspberryJuice)

Uses
* [SpigotMC](https://hub.spigotmc.org/stash/projects/SPIGOT/repos/spigot/browse) version 1.12.2
  (via latest [buildtools](https://hub.spigotmc.org/stash/projects/SPIGOT/repos/buildtools/browse) snapshot)
* [RaspberryJuice](https://github.com/zhuowei/RaspberryJuice) version 1_12_1

### Start the server

If you have a container image available (see below) just run the `mc-rjuice.sh` wrapper script.

The script will start a SpigotMC server with the RaspberryJuice plugin enabled.
Edit `mc-rjuice.sh` to change the container/host port mapping if you want a different port.

```shell
cd run
./mc-rjuice.sh
```

**NOTE** that by default, the raspberryjuice port (4711) is only exposed to localhost.
If you like to change that please edit `mc-rjuice.sh` accordingly.

There's a systemd unit file `minecraft-raspberryjuice.service` which lets you start the server automatically.
To activate, run as `root`:

```shell
mkdir -p /opt/minecraft-raspberryjuice
cp -r run/* /opt/minecraft-raspberryjuice
mv /opt/minecraft-raspberryjuice/minecraft-raspberryjuice.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable --now minecraft-raspberryjuice.service
```

### Build the docker image

This will create the docker image on your server.
Only required once.

```shell
cd build
docker build -t minecraft-raspberryjuice:1.12.1 .
```
