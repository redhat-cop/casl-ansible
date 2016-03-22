#  rhc-ose ansible Automation

Automation of OpenShift 3 using [Ansible](http://www.ansible.com/)

## **Note: This section is currently under active development.**

## Roles

The following are a list of Absible roles available

* cicd - Installs and configures CICD tools such as Jenkins and Nexus
* cicd-common - Sets common CICD related facts
* common - Provides for the generation of an environment id per execution and sets common facts
* openshift-common - Sets common OpenShift related facts
* openshift-provision - Installs and configures OpenShift on a set of masters and nodes (Work in Progress)
* openstack-create - Creates an OpenStack instances and attaches block storage

## Playbooks

The following are a list of Ansible playbooks

* OpenShift Provision (ose-provision.yml)
    * Provision machines on OpenStack for OpenShift
	    * Attach persistent storage
	    * Update machines with latest packages
        * Additional work in progress
* Continuous Integration/Continuous Delivery (cicd-provision.yml)
	* Provision instance on OpenStack
		* Attach persistent storage
	* Install prerequisite packages
	* Install and configure Java, Groovy, Maven, Jenkins, Nexus, Docker


## Provisioning an OpenShift Environment

### Prerequisites

A client environment with the appropriate entitlements to Red Hat Enterprise 7 and OpenShift Enterprise 3 is required to provision new OpenShift environments. A [host builder docker image](../docker/openshift-host-builder) is available to provide an execution environment. 

### Configuring the Inventory

The current supported method of provisioning new OpenShift environments is to utilize OpenStack. The `openstack_key_name` in the `ose3` inventory file at the root of this folder must have the SSH key name specified in order for Ansible to be able to communicate with the newly provisioned machines

### Running the OpenShift Playbook
 
Execute the following command to run the playbook

    ansible-playbook -i inventory/ose-provision ose-provision.yml
    

### Running the CICD Playbook
 
Execute the following command to run the playbook

    ansible-playbook -i inventory/cicd-provision cicd-provision.yml
    

