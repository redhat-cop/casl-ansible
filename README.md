#  CASL Ansible

Automation of OpenShift using [Ansible](http://www.ansible.com/).
(This includes automation of OpenShift Cluster provisioning as well as other automation tasks post-provisioning.)

## Provisioning A Cluster

The CASL Ansible tools provide everything needed to automatically provision an OpenShift cluster from scratch. Visit the provisioning guide relevant to you to get started.

* [Provisioning a Cluster on OpenStack](./PROVISIONING_OPENSTACK.md)

## Compatability Matrix

The CASL repos have several dependencies on external repositories, such as:

* [Infra Ansible](https://github.com/redhat-cop/infra-ansible) - A repository of Ansible automation for generic infrastructure components
* [OpenShift Ansible](https://github.com/openshift/openshift-ansible) - The core OpenShift Installer
* [OpenShift Ansible Contrib](https://github.com/openshift/openshift-ansible-contrib) - A repo of extra, unsupported, and upstream ansible roles and playbooks for OpenShift

> **_hint_** right-click the `openshift-ansible` version number in the table below and copy the URL

Below is a list of versions the CASL team has leveraged and found to be stable/working. Note that other versions may work as well. Feel free to submit PRs for this file with updated versions as they are found to be functional.

| casl-ansible version | OpenShift version | openshift-ansible version | openshift-ansible-contrib version | infra-ansible version |
|:-------------------------:|:-----------------:|:-----------:|:------------:|:-------------:|
| [v3.6.1](https://github.com/redhat-cop/casl-ansible/releases/tag/v3.6.1) | OCP 3.6.x | [3.6.173.0.45-1](https://github.com/openshift/openshift-ansible/archive/openshift-ansible-3.6.173.0.45-1.tar.gz) | [v3.6.0](https://github.com/openshift/openshift-ansible-contrib/releases/tag/v3.6.0) | master |
| [v3.6.0](https://github.com/redhat-cop/casl-ansible/releases/tag/v3.6.0) | OCP 3.6.x | [3.6.173.0.45-1](https://github.com/openshift/openshift-ansible/archive/openshift-ansible-3.6.173.0.45-1.tar.gz) | [v3.6.0](https://github.com/openshift/openshift-ansible-contrib/releases/tag/v3.6.0) | master |
| [v3.5.0](https://github.com/redhat-cop/casl-ansible/releases/tag/v3.5.0) | OCP 3.5.x | [3.5.77-1](https://github.com/openshift/openshift-ansible/archive/openshift-ansible-3.5.77-1.tar.gz) | [v3.5.0](https://github.com/openshift/openshift-ansible-contrib/releases/tag/v3.5.0) | master |
| [v1.0.1](https://github.com/redhat-cop/casl-ansible/releases/tag/v1.0.1) | OCP 3.4 | [3.4.50-1](https://github.com/openshift/openshift-ansible/archive/openshift-ansible-3.4.60-1.tar.gz) | n/a | n/a |
| [v1.0.0](https://github.com/redhat-cop/casl-ansible/releases/tag/v1.0.0) | OCP 3.4 | [3.4.50-1](https://github.com/openshift/openshift-ansible/archive/openshift-ansible-3.4.60-1.tar.gz) | n/a | n/a |
