# Contributing a New Provisioner

Building a provisioner for a new cloud provider is fairly straight forward, thanks to our pluggable [provisioning architecture](PROVSIONING_ARCH.md).

Here's what you need.

Create a new directory called `/playbooks/openshift/my_provisioner`.

Create a new playbook called `/playbooks/openshift/my_provisioner/provision.yml`

Build Roles for your provisioner. When it comes to building a provisioning role 

```
- import_playbook: ../common/inventory_refresh.yml
```
