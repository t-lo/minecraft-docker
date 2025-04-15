#!/bin/bash

set -euo pipefail

if [[ $# -ne 1 ]] ; then
    echo "Usage: $0 <server>"
    echo "Create direwolf backup and download to local directory."
    echo
    exit 1
fi

server="$1"
backup_name="direwolf-backup-$(date --rfc-3339 seconds | sed 's/[ :]/_/g').tgz"

script_dir="$(cd "$(dirname "$0")"; pwd)"
source "${script_dir}/backup.inc"

echo "### Stopping '$service' on '$server'"
ssh "core@${server}" "sudo systemctl stop $service"

echo "### Creating backup file '$backup_name' on '$server'."
ssh "core@${server}" "tar czvf ${backup_name} ${backup_paths[@]}"

echo "### Downloading '$backup_name' from '$server'."
scp "core@${server}:$backup_name" .

echo "### Removing backup file '$backup_name' from '$server'."
ssh "core@${server}" "rm  ${backup_name}"

echo "### Starting '$service' on "$server""
ssh "core@${server}" "sudo systemctl start $service"

echo "### ALL DONE; '$backup_name' is now available."
