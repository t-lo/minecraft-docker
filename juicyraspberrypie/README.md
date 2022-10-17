# Dockerised minecraft Python API (via Spigot / JuicyRaspberryPie)

This is based on a fork of the original raspberryjuice; the fork continues to be maintained and supports more recent Minecraft versions.

Uses
* [SpigotMC](https://hub.spigotmc.org/stash/projects/SPIGOT/repos/spigot/browse) version 1.18.1
  (via latest [buildtools](https://hub.spigotmc.org/stash/projects/SPIGOT/repos/buildtools/browse) snapshot)
* [RaspberryJuice](https://github.com/wensheng/JuicyRaspberryPie) v0.3 (for spigot 1.18.1)

### Start the server

If you have a container image available (see below) just run the `mc-juicy.sh` wrapper script.
The script will start a SpigotMC server with the JuicyRaspberryPie plugin enabled.

```shell
cd run
./mc-juicy.sh
```

**NOTE** that by default, the JuicyRaspberryPie port (4711) is only exposed to localhost.
This implies that while you can run python code outside the container, you won't be able to run it outside the server the container runs on.
If you like to change that please edit `mc-juicy.sh` accordingly - but note that there are security implications since the remote control port is not authenticated.

There's a systemd unit file `minecraft-juicyraspberrypie.service` which lets you start the server automatically.
To activate, run as `root`:

```shell
mkdir /opt/minecraft-juicyraspberrypie
cp -r run/* /opt/minecraft-juicyraspberrypie
mv /opt/minecraft-juicyraspberrypie/minecraft-juicyraspberrypie.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable --now minecraft-juicyraspberrypie.service
```

### Getting the python (client) bindings

JuicyRaspberryPie requires updated python bindings - the pypi `mcpi` pip module will not work.
To work around this, download the updated bindings and put them into an `mcpi` sub-folder in the folder of your python project.
Then make it a python module so you can import it:

```shell
wget https://github.com/wensheng/JuicyRaspberryPie/archive/refs/tags/v0.3.tar.gz
tar -xzf v0.3.tar.gz --strip-components=5 JuicyRaspberryPie-0.3/bukkit/src/main/resources/mcpi
touch __init__.py mcpi/__init__.py
```

If you want to use python 3 then you'll also need this one-line patch: https://github.com/wensheng/JuicyRaspberryPie/pull/9/files

Now you can `from mcpi.minecraft import Minecraft, mcpy` in your python code.

### Build the docker image

This will create the docker image on your server.
Only required once.

```shell
cd build
docker build -t minecraft-juicyraspberrypie:1.18.1 .
```
