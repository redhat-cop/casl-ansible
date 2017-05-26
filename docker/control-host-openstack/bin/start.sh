#!/bin/bash

# start.sh - Helper script that is executed when the Docker container is started up to arrange files in the proper locations

SSH_DIR=/root/.ssh
INPUT_SSH_DIR=/mnt/.ssh
CONFIG_DIR=/root/.config/openstack

daemonize() {
  while true; do sleep 500; done
}

# Copy mounted .ssh directory to ~/.ssh
if [ -d "${INPUT_SSH_DIR}" ]; then

	mkdir -p $SSH_DIR
	cp $INPUT_SSH_DIR/* $SSH_DIR/

fi

# Attempt to source the RC file for OpenStack
# - note: if more than one file, only the first one will be sourced 
if [ -d "${CONFIG_DIR}" ]; then

	FILES=$CONFIG_DIR/*.sh
	rc_files=($FILES)
	echo "Sourcing ${rc_files[0]}"
	source ${rc_files[0]}

fi

echo "export TERM=xterm" >> /root/.bashrc

if [ "$1" == "daemonize" ];then	
  grep -q -F "source ${rc_files[0]}" /root/.bashrc || echo "source ${rc_files[0]}" >> /root/.bashrc
  daemonize
  shift
fi

exec "$@"
