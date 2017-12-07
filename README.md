#  CASL Ansible

Automation of OpenShift and Container related tasks using [Ansible](http://www.ansible.com/).
(This includes automation of OpenShift Cluster provisioning as well as other automation tasks post-provisioning.)

# Automation Topics

## Provisioning An OpenShift Cluster

The CASL Ansible tools provide everything needed to automatically provision an OpenShift cluster from scratch. Visit the provisioning guide relevant to you to get started.

* [Provisioning an OpenShift Cluster on OpenStack](./docs/PROVISIONING_OPENSTACK.md)
* [Provisioning an OpenShift Cluster on AWS](./docs/PROVISIONING_AWS.md)


## Automation of OpenShift Cluster Content

The [openshift-applier](roles/openshift-applier) is used to automate the seeding of OpenShift cluster content based on OpenShift templates and parameters files.


## Compatibility Matrix

For some tasks, the CASL repository has several dependencies on external repositories, such as:

* [Infra Ansible](https://github.com/redhat-cop/infra-ansible) - A repository of Ansible automation for generic infrastructure components
* [OpenShift Ansible](https://github.com/openshift/openshift-ansible) - The core OpenShift Installation Playbooks (and supporting roles)
* [OpenShift Ansible Contrib](https://github.com/openshift/openshift-ansible-contrib) - A repository of extra, unsupported, and upstream Ansible roles and playbooks for OpenShift

> **Note:** The dependencies are managed using `ansible-galaxy` and the specific instructions will call this out when there is a need to use galaxy to pull in the correct dependencies.

Below is a list of versions of `openshift-ansible` the CASL team has leveraged and found to be stable/working. Note that other versions may work as well. Feel free to submit PRs for this file with updated versions as they are found to be functional.

> **_hint_** right-click the `openshift-ansible` version number in the table below and copy the URL

| casl-ansible version | OpenShift version | openshift-ansible version | openshift-ansible-contrib version | infra-ansible version |
|:-------------------------:|:-----------------:|:-----------:|:------------:|:-------------:|
| [master](https://github.com/redhat-cop/casl-ansible/archive/master.tar.gz) | OCP 3.7.x | [3.7.11-1](https://github.com/openshift/openshift-ansible/archive/openshift-ansible-3.7.11-1.tar.gz) | [v3.6.0](https://github.com/openshift/openshift-ansible-contrib/releases/tag/v3.6.0) | master |
| [v3.6.1](https://github.com/redhat-cop/casl-ansible/releases/tag/v3.6.1) | OCP 3.6.x | [3.6.173.0.45-1](https://github.com/openshift/openshift-ansible/archive/openshift-ansible-3.6.173.0.45-1.tar.gz) | [v3.6.0](https://github.com/openshift/openshift-ansible-contrib/releases/tag/v3.6.0) | master |
| [v3.6.0](https://github.com/redhat-cop/casl-ansible/releases/tag/v3.6.0) | OCP 3.6.x | [3.6.173.0.45-1](https://github.com/openshift/openshift-ansible/archive/openshift-ansible-3.6.173.0.45-1.tar.gz) | [v3.6.0](https://github.com/openshift/openshift-ansible-contrib/releases/tag/v3.6.0) | master |
| [v3.5.0](https://github.com/redhat-cop/casl-ansible/releases/tag/v3.5.0) | OCP 3.5.x | [3.5.77-1](https://github.com/openshift/openshift-ansible/archive/openshift-ansible-3.5.77-1.tar.gz) | [v3.5.0](https://github.com/openshift/openshift-ansible-contrib/releases/tag/v3.5.0) | master |
| [v1.0.1](https://github.com/redhat-cop/casl-ansible/releases/tag/v1.0.1) | OCP 3.4 | [3.4.50-1](https://github.com/openshift/openshift-ansible/archive/openshift-ansible-3.4.60-1.tar.gz) | n/a | n/a |
| [v1.0.0](https://github.com/redhat-cop/casl-ansible/releases/tag/v1.0.0) | OCP 3.4 | [3.4.50-1](https://github.com/openshift/openshift-ansible/archive/openshift-ansible-3.4.60-1.tar.gz) | n/a | n/a |
