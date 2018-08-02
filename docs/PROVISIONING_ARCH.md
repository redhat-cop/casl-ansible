# Automated Provisioning Architecture

The CASL automated provisioning framework provides an opinionated architecture for handling automated provisioning of OpenShift clusters on any _automatable_ infrastructure. This document describes the architecture and principles

## Four Phased Approach

A provisioning run should be split into four (4) phases as represented in our [end-to-end.yml](/playbooks/openshift/end-to-end.yml) playbook:


```yaml
---
# Provision Openstack Instances
- import_playbook: provision-instances.yml <1>

# Pre-Install Steps
- import_playbook: pre-install.yml <2>

# Install - this runs openshift-ansible
- import_playbook: install.yml <3>

# Post Install
- import_playbook: post-install.yml <4>
```

1. _Provision Infrastructure_ creates the servers/instances and any other supporting infrastructure required (network, DNS, load balancers, etc.). In general this phase
  - Begins with having credentials with proper access to an Infrastructure provider.
  - Ends with servers provisioned and running with an OS installed and SSH keys (with root or sudo) pushed.
2. _Pre-Install_ handles all of the host prep you'd expect to happen when preparing to install OpenShift. This phase includes:
  - Subscribing the hosts via `subscription-manager` (supports individual account or Satellite subscription using _activation keys_)
  - Installing/configuring the container runtime, including container storage devices
  - Installing prerequisite packages
  - Updating packages (and rebooting hosts)
3. _Install_ runs the normal openshift installation playbook using [openshift-ansible](https://github.com/openshift/openshift-ansible.git). This means that any features of the native openshift installer are available to use with CASL provisioning. (see [OpenShift Ansible Integration](#openshift-ansible-integration) below)
4. _Post Install_ covers any additional configurations or deployments that we would like to have happen that isn't provided by the native installer. This can include:
  - Syncing additional administrator SSH keys (typically a cloud provider only provisions a single key)
  - Creating a set of demo users (when using the `HTPassswordIdentityProvider`)
  - Creation of any sort of OpenShift resources using the [openshift-applier](https://github.com/redhat-cop/openshift-applier.git) automation framework.

Some principles we try to adhere to with all of these phases include the following.

- **Modularity**. Each phase should be runnable on its own, using the exact same inventory
- **Idempotency**. All phases should be safe to re-run at any time without impact.
- **Commonality**. This is the idea that we should essentially treat all Infrastructure providers the same, allowing us to treat different providers as _pluggable_ to a [common provisioning framework](#pluggable-provisioners).
- **Ability to Deprovision**. Provisioner should include the ability to clean up all created infrastructure.

## OpenShift Ansible integration

CASL-Ansible provisioning is intended to be a complement (and in some cases an upstream) to the [openshift-ansible](https://github.com/openshift/openshift-ansible.git) repo. As such, we intend for the CASL tools to support all of the features and capabilities of the openshift-ansible cluster deployment playbook. The aim is to use CASL to provision and prepare infrastructure and then hand off to the [deploy_cluster](https://github.com/openshift/openshift-ansible/blob/master/playbooks/deploy_cluster.yml) playbook for the installation of OpenShift.

## Ansible Inventory Structure

One of the keys to be able to accomplish the above is the way that we take advantage of many inventory features of Ansible. We _never generate inventory_ in our playbooks or roles which allows us to use a common inventory to run against any of our modular phases, _including the ability to run directory against openshift-ansible playbooks_. We accomplish this by taking advantage of the following Ansible Inventory features:

- [Inventory Directories](http://docs.ansible.com/ansible/latest/intro_dynamic_inventory.html#using-inventory-directories-and-multiple-inventory-sources) consisting of:
  - [Dynamic Inventory Scripts](http://docs.ansible.com/ansible/latest/intro_dynamic_inventory.html#using-inventory-directories-and-multiple-inventory-sources)
  - [Static Groups of Dynamic Groups](http://docs.ansible.com/ansible/latest/intro_dynamic_inventory.html#static-groups-of-dynamic-groups)
  - [Separated Host and Variable Data](http://docs.ansible.com/ansible/latest/intro_inventory.html#splitting-out-host-and-group-specific-data)

## Pluggable Provisioners

The _Provision Infrastructure_ phase of CASL is intended to be pluggable. This means that, no matter what cloud or infrastructure you are provisioning on, you should always run the exact same playbook(s), and may choose the target provider with an ansible variable.

```
# Provision Openstack Instances
- import_playbook: openstack/provision.yml
  when: hosting_infrastructure == "openstack"

# Provision Openstack Instances
- import_playbook: aws/provision.yml
  when: hosting_infrastructure == "aws"
```

## Defining Cloud Infrastructure

In order to support a cloud agnostic way of defining the infrastructure stack that should be provisioned, we support the use of a `cloud_infrastructure` dictionary. See `inventory/sample.<cloud provider>.example.com/inventory/group_vars/all.yml` for examples.

## Adding New Provisioners

See [Contributing a Provisioner](CONTRIBUTE_PROVISIONER.md) for more details.
