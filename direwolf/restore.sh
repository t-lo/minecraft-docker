#!/bin/bash

set -euo pipefail

if [[ $# -ne 2 ]] ; then
    echo "Usage: $0 <backup-file> <server>"
    echo "Restore direwolf backup from local file <backup-file> on <server>."
    echo
    exit 1
fi

backup_name="$1"
server="$2"

backup_file="$(basename "${backup_name}")"

script_dir="$(cd "$(dirname "$0")"; pwd)"
source "${script_dir}/backup.inc"

echo "### Stopping '$service' on '$server'"
ssh "core@${server}" "sudo systemctl stop $service"

echo "### Uploading '$backup_name' to '$server'."
scp "$backup_name" "core@${server}:${backup_file}"

echo "### Deleting server state to ensure clean restore."
ssh "core@${server}" "sudo rm -rvf ${backup_paths[@]}"

echo "### Restoring '$backup_name' on '$server'."
ssh "core@${server}" "sudo tar -f ${backup_file} -C / -xzv --group direwolf --owner direwolf"
# FIXUP: data is included in path but only contains subdirectories. So tar
# doesn't set ownership correctly.
ssh "core@${server}" "sudo chown direwolf:direwolf /opt/direwolf-server/data"

echo "### Removing backup file '$backup_file' from '$server'."
ssh "core@${server}" "rm  ${backup_file}"

echo "### Enabling and starting '$service' on "$server""
ssh "core@${server}" "sudo systemctl enable --now $service"
ssh "core@${server}" "sudo systemctl start $service"

echo "### ALL DONE; '$backup_name' was restored to '$server'."
