#!/bin/sh

echo
echo
echo "### Synchronising data volume"
echo

cd /minecraft-server

rsync --archive --update --verbose \
      --exclude '**/world*' \
      . \
      /minecraft-server-data

echo
echo
echo "### Starting server"
echo
cd /minecraft-server-data

set -x
echo "${USER_JVM_ARGS}" > user_jvm_args.txt
exec "${@}"
