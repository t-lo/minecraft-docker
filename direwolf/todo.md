# TODO list

## Configurable target directories

### Features

1. Move away from hard-coded `/opt/direwolf-server` and towards configurable
   service data directories
2. Support for multiple services on the same node

### Implementation

1. Put minecraft working dirs, RAM etc. in env files in `/etc`
2. Start / entrypoint scripts in separate directory in `/opt`
3. Backup and restore scripts source vars from node's env

**Affected files + Plan for action:**
* backup.inc - move to node's `/etc`, source env from backup + restore scripts
* build-direwolf-container.service - use env from ` /etc` (for stamp file)
* direwolf-server.service - use env from ` /etc` (working dir / data)
* provisioning.yaml - env to `/etc` and generic paths to `/opt/`.
  Rename 'direwolf' user to 'minecraft'
* README.md - update to match new behaviour
* backup.sh, restore.sh - source env from node.

