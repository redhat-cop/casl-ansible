#  CASL Ansible

Automation of OpenShift and Container related tasks using [Ansible](http://www.ansible.com/).
(This includes automation of OpenShift Cluster provisioning as well as other automation tasks post-provisioning.)

# Automation Topics

## Provisioning An OpenShift Cluster

The CASL Ansible tools provide everything needed to automatically provision an OpenShift cluster from scratch. Visit the provisioning guide relevant to you to get started.

* [Provisioning an OpenShift Cluster on OpenStack](./docs/PROVISIONING_OPENSTACK.md)
* [Provisioning an OpenShift Cluster on AWS](./docs/PROVISIONING_AWS.md)
* [Provisioning an OpenShift Cluster on GCP](./docs/PROVISIONING_GCP.md)


## Automation of OpenShift Cluster Content

(moved to a new repo - https://github.com/redhat-cop/openshift-applier)
The [openshift-applier](https://github.com/redhat-cop/openshift-applier) is used to automate the seeding of OpenShift cluster content based on OpenShift templates and parameters files.


## Compatibility Matrix

For some tasks, the CASL repository has several dependencies on external repositories, such as:

* [Infra Ansible](https://github.com/redhat-cop/infra-ansible) - A repository of Ansible automation for generic infrastructure components
* [OpenShift Ansible](https://github.com/openshift/openshift-ansible) - The core OpenShift Installation Playbooks (and supporting roles)
* [OpenShift Ansible Contrib](https://github.com/openshift/openshift-ansible-contrib) - A repository of extra, unsupported, and upstream Ansible roles and playbooks for OpenShift

> **Note:** The dependencies are managed using `ansible-galaxy` and the specific instructions will call this out when there is a need to use galaxy to pull in the correct dependencies.

