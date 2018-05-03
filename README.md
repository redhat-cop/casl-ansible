#  CASL Ansible

Automation of OpenShift and Container related tasks using [Ansible](http://www.ansible.com/).
(This includes automation of OpenShift Cluster provisioning as well as other automation tasks post-provisioning.)

## What can I do with CASL tools?

### Provision Architecture

CASL Ansible aims to provide a common experience for provisioning infrastructure for OpenShift across a number of Infrastructure providers.

The [CASL Architecture Overview](./docs/PROVISIONING_ARCH.md) documentation gives an overview of how we approach the end to end automation of standing up OpenShift Clusters.

Additionally, we have several fully automated provisioners through which you can stand up an OpenShift cluster.

* [Provisioning an OpenShift Cluster on OpenStack](./docs/PROVISIONING_OPENSTACK.md)
* [Provisioning an OpenShift Cluster on AWS](./docs/PROVISIONING_AWS.md)
* [Provisioning an OpenShift Cluster on GCP](./docs/PROVISIONING_GCP.md)

### Automation of Cluster Installation on Your Own (BYO) Infrastructure

For those who are using infrastructure that is either not yet fully automated, or not yet supported through a CASL provider, we provide a [Bring Your Own Infrastructure](./docs/BYO_INFRASTRUCTURE.adoc) guide to using CASL.

### Automation of OpenShift Cluster Content

(moved to a new repo - https://github.com/redhat-cop/openshift-applier)
The [openshift-applier](https://github.com/redhat-cop/openshift-applier) is used to automate the seeding of OpenShift cluster content based on OpenShift templates and parameters files.


## Compatibility Matrix

For some tasks, the CASL repository has several dependencies on external repositories, such as:

* [Infra Ansible](https://github.com/redhat-cop/infra-ansible) - A repository of Ansible automation for generic infrastructure components
* [OpenShift Ansible](https://github.com/openshift/openshift-ansible) - The core OpenShift Installation Playbooks (and supporting roles)
* [OpenShift Ansible Contrib](https://github.com/openshift/openshift-ansible-contrib) - A repository of extra, unsupported, and upstream Ansible roles and playbooks for OpenShift

> **Note:** The dependencies are managed using `ansible-galaxy` and the specific instructions will call this out when there is a need to use galaxy to pull in the correct dependencies.
