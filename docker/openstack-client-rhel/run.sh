#!/bin/bash

# Run.sh - Script to build and run a Docker container to provision OpenShift environments


SCRIPT_BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
OPENSTACK_CONFIG_DIR=~/.openstack/
OPENSTACK_CLIENT_IMAGE="rhtconsulting/openshift-host-builder"
SSH_DIR=~/.ssh
REMOVE_CONTAINER_ON_EXIT="--rm"
REPOSITORY=
REPOSITORY_VOLUME=""


usage() {
    echo "
     Usage: $0 [options]
     Options:
     --configdir=<configdir>       : Directory containing Openstack configuration files (Default: ~/.openstack/)
     --image-name=<name>           : Name of the image to build or use (Default: rhtconsulting/openshift-host-builder)
     --keep                        : Whether to keep the the container after exiting
     --ssh=<ssh>                   : Location of SSH keys to mount into the container (Default: ~/.ssh)
     --repository=<repository>     : Directory containing a repository to mount inside the container
     --help                        : Show Usage Output
	 "
}



# Process Input

for i in "$@"
do
  case $i in
    -c=*|--configdir=*)
      OPENSTACK_CONFIG_DIR="${i#*=}"
      shift;;
	  -k|--keep)
      REMOVE_CONTAINER_ON_EXIT=""
      shift;;
  	-n=*|--image-name=*)
      OPENSTACK_CLIENT_IMAGE="${i#*=}"
      shift;;
    -s=*|--ssh=*)
      SSH_DIR="${i#*=}"
	  shift;;
  	-r=*|--repository=*)
      REPOSITORY="${i#*=}"
      shift;;
    -h|--help)
      usage;
      exit 0;
      ;;
    *)
      echo "Invalid Option: ${i#*=}"
      usage;
      exit 1;
      ;;
  esac
done


if [ ! -d ${OPENSTACK_CONFIG_DIR} ]; then
	echo "ERROR: OpenStack configuration directory not found!"
	exit 1
fi

DOCKER_IMAGES=$(docker images)

if [ $? -ne 0 ]; then
    echo "Error: Failed to determine installed docker images. Please verify connectivity to Docker socket."
    exit 1
fi

OPENSTACK_IMAGE=$(echo -e "${DOCKER_IMAGES}" | awk '{ print $1 }' | grep ${OPENSTACK_CLIENT_IMAGE})

if [ $? -gt 1 ]; then
  echo "Error: Failed to parse the Docker images to find ${OPENSTACK_CLIENT_IMAGE} image."
  exit 1
fi

# Check if Image has been build previously
if [ -z $OPENSTACK_IMAGE ]; then
	echo "Building Docker Image ${OPENSTACK_CLIENT_IMAGE}...."
	docker build -t ${OPENSTACK_CLIENT_IMAGE} ${SCRIPT_BASE_DIR}
fi

# Check if Image has been build previously
if [ ! -z ${REPOSITORY} ]; then

	if [ ! -d ${REPOSITORY} ]; then
		echo "Error: Could not locate specified repository directory"
		exit 1
	fi

	REPOSITORY_VOLUME="-v ${REPOSITORY}:/root/repository:z"

	echo
	echo "Git Repository containing scripts are found and mounted in the '/root/repository' folder"
fi

if [ -d $SSH_DIR ]; then
	SSH_VOLUME="-v ${SSH_DIR}:/mnt/.ssh:z"
else
	echo "Warning: SSH Directory not found"
fi


echo "Starting OpenStack Client Container...."
echo
docker run -it ${REMOVE_CONTAINER_ON_EXIT} -v ${OPENSTACK_CONFIG_DIR}:/root/.openstack:z ${REPOSITORY_VOLUME} ${SSH_VOLUME} ${OPENSTACK_CLIENT_IMAGE}

