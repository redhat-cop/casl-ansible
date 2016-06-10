#!/bin/bash

provision() {
  # Run provision playbook to create the base environment
  ansible-playbook -i ${INVENTORY_FILE} ./ose-provision.yml

  # Grab newly create inventory file
  openshift_inventory=$(ls -Art inventory_* | tail -n 1)

  # Run the OpenShift Installer
  ansible-playbook -i ${openshift_inventory} ${INSTALLER_PATH}/playbooks/byo/config.yml
}

# Process input
for i in "$@"
do
  case $i in
    --inventory=*|-i=*)
      INVENTORY_FILE="${i#*=}"
      shift;;
    --installer-path=*|-p=*)
      INSTALLER_PATH="${i#*=}"
      shift;;
    --help|-h)
      usage
      exit 0;;
    *)
      echo "Invalid Option: ${i%=*}"
      exit 1;
      ;;
  esac
done

provision
