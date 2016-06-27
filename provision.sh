#!/bin/bash

SCRIPT_BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

## Functions
source ${SCRIPT_BASE_DIR}/library/helpers

provision() {
  # Run provision playbook to create the base environment
  ansible-playbook ${ANSIBLE_OPTS} ${SCRIPT_BASE_DIR}/ose-provision.yml || error_out "Provisioning Failed." 1

  # Grab newly create inventory file
  openshift_inventory=$(find . -maxdepth 1 -name 'inventory_*' | sort | tail -n 1)
  [ -f "${openshift_inventory}" ] || error_out "No inventory file has been written at location: '${openshift_inventory}'" 1

  # Run the OpenShift Installer
  command="ansible-playbook -i ${openshift_inventory} ${INSTALLER_PATH}/playbooks/byo/config.yml "
  $command || error_out "OpenShift Installer failed to run with: ${command}" 1
}

usage() {
  echo "Container Automation Solutions Lab provisioning"
  echo ""
  echo "Usage: $0 [options]"
  echo ""
  echo "Options:"
  echo "  --inventory=<file>|-i=<file>                : Path to an ansible inventory file (defaults to /etc/ansible/hosts)"
  echo "  --installer-path=<directory>|-p=<directory> : Path to the openshift-ansible directory (/usr/share/ansible/openshift-ansible -- location atomic-openshift-utils install to)"
  echo "  --help|-h                                   : Show help output"
}

# Process input
for i in "$@"
do
  case $i in
    --inventory=*|-i=*)
      INVENTORY_FILE="${i#*=}"
      ANSIBLE_OPTS="-i ${INVENTORY_FILE}"
      shift;;
    --installer-path=*|-p=*)
      INSTALLER_PATH="${i#*=}"
      shift;;
    --help|-h)
      usage
      exit 0;;
    *)
      echo "Invalid Option: ${i%=*}. Try running with --help to get some help."
      exit 1;
      ;;
  esac
done

INSTALLER_PATH=${INSTALLER_PATH:-'/usr/share/ansible/openshift-ansible'}

provision
