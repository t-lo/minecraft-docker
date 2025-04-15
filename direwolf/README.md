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

Complementary systemd services for automated build and start are included.
All services use `/opt/direwolf-server` working directory and run as user
`direwolf`. `/opt/direwolf-server` must contain `build.sh`, `Dockerfile`,
`entry.sh`, and `start-docker.sh`.
* `build-direwolf-container.service` - build the direwolf container.
* `direwolf-server.service` - start the direwolf container.
   Requires successful build.
* `direwolf-server.socket` - Socket unit connecting the direwolf service to `/run/direwolf-cmd`.
  The socket can be used to interact with the server
  (`echo <command> > /run/direwolf-cmd`) and is required for graceful shutdown.

## Provisioning automation

A complementary [Flatcar Container Linux](https://www.flatcar.org) provisioning
automation is included, allowing for zero-touch on-demand deployments.
For details, refer to [`provisioning.yaml`](provisioning.yaml), which uses
[butane syntax](provisioning.yaml).
A pre-transpiled JSON ignition config is available in
[`provisioning.json`](provisioning.json).

## Backup and restore

The automation includes simple scripts for backing up and restoring the server.
These can also be used to move the server to a different instance without losing state.

* `backup.sh <server>` generates a backup.
  - The minecraft service will be stopped for the backup, and restarted afterwards.
  - The backup will create a tarball on the server and download it.
  - The server's `world/`, `backups/`, and whitelist / op / banned configurations will be included.
  - The backup is performed via SSH and SCP; the automation expects the local
    ssh client to be configured appropriately (correct keys etc. set in ´~/.ssh/config`).
* `restore.sh <tarball> <server>` restores a backup.
  - The minecraft service will be stopped for the restore, and restarted afterwards.
  - **All remote state on `<server>` will be deleted before restoring.**

## Local testing

Using Flatcar's qemu release, the above can be tested locally.

First, acquire the latest Flatcar release. Note the below is for the x86-64
architecture; replace `amd64-usr` with `arm64-usr` for aarch64.
```
wget https://alpha.release.flatcar-linux.net/amd64-usr/current/flatcar_production_qemu_uefi.sh
chmod +x flatcar_production_qemu_uefi.sh
wget https://stable.release.flatcar-linux.net/amd64-usr/current/flatcar_production_qemu_uefi_image.img
wget https://stable.release.flatcar-linux.net/amd64-usr/current/flatcar_production_qemu_uefi_efi_code.qcow2
wget https://stable.release.flatcar-linux.net/amd64-usr/current/flatcar_production_qemu_uefi_efi_vars.qcow2
```

Now start a local qemu VM using the wrapper script, pass the provisioning config, and forward the relevant ports:
```
./flatcar_production_qemu_uefi.sh -i provisioning.json -M 8G -f 25565:25565 -f 25575:25575 -- -nographic -snapshot
```
The above grants the VM 8GM of host memory; this should be the minimum for testing as the server is rather memory hungry.

**NOTE**: The `-snapshot` option will start qemu in ephemeral mode.
No changes will ever be written to the disk image.
After the VM is shut down, _everything_ in the VM will be lost.
(It comes in handy for testing deployments though, as the disk image remains
 pristine and can be re-used indefinitely.)

After start-up, the container image will be built, then started.
You can follow the container build process via the serial console:
```
journalctl -f -u build-direwolf-container.service
```

After the build concluded, you can access the server logs via:
```
journalctl -f -u direwolf-server.service
```

As soon as the server is ready, you can connect clients to the local VM (use
`localhost` or `127.0.0.1` as server address).
If your host's firewall allows, you can even connect clients remotely via the
local network your host system is in.

The qemu wrapper `./flatcar_production_qemu_uefi.sh` tries to auto-detect SSH
keys and will add local public keys to the VM automatically.
It will open an SSH port forward on the host on port 2222.
You can SSH into the vm via `ssh -p 2222 core@localhost`.


In order to test `backup.sh` and `restore.sh` we need to add a configuration
snippet for the test VM to `~/.ssh/config`:
```
host flatcar-vm
user core
hostname localhost
port 2222
```

This should now work:
* `backup.sh flatcar-vm`
  (make note of backup file name for restore)
* `restore.sh <backup-file> flatcar-vm`
