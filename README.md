#  rhc-ose ansible Automation

Automation of OpenShift 3 using [Ansible](http://www.ansible.com/)

## **Note: This section is currently under active development.**

## Features

The following features are currently available:

* Provision machines on OpenStack for OpenShift
	* Attach persistent storage
	* Update machines with latest packages

## Provisioning an OpenShift Environment

### Prerequisites

A client environment with the appropriate entitlements to Red Hat Enterprise 7 and OpenShift Enterprise 3 is required to provision new OpenShift environments. A [host builder docker image](../docker/openshift-host-builder) is available to provide an execution environment. 

### Configuring the Inventory

The current supported method of provisioning new OpenShift environments is to utilize OpenStack. The `openstack_key_name` in the `ose3` inventory file at the root of this folder must have the SSH key name specified in order for Ansible to be able to communicate with the newly provisioned machines

 ### Running the Playbook
 
Execute the following command to run the playbook

    ansible-playbook -i ose3 site.yml

