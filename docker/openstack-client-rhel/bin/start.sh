#!/bin/bash

# start.sh - Helper script that is executed when the Docker container is started up to arrange files in the proper locations

SSH_DIR=/root/.ssh
INPUT_SSH_DIR=/mnt/.ssh
CONFIG_DIR=/root/.openstack

# Copy mounted .ssh directory to ~/.ssh
if [ -d $INPUT_SSH_DIR ]; then

	mkdir -p $SSH_DIR
	cp $INPUT_SSH_DIR/* $SSH_DIR/

fi

# Attempt to source files for OpenStack
if [ -d $CONFIG_DIR ]; then

	FILES=$CONFIG_DIR/*.sh

	for file in $FILES
	do
		source $file
	done

fi

exec "$@"

