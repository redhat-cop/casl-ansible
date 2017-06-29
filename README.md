#  CASL Ansible

Automation of OpenShift 3 using [Ansible](http://www.ansible.com/)

## Provisioning Quickstart

### Local Setup (one time, only)

In addition to _cloning this repo_, you'll need the following:

* Access to an OpenStack environment using an [OpenStack RC File](http://docs.openstack.org/user-guide/common/cli-set-environment-variables-using-openstack-rc.html)
  * File should be placed at `~/.config/openstack/openrc.sh`
>**NOTE**: OpenStack environment currently requires Heat to be enabled, and the user must have the `heat_stack_owner` role assigned.
* A [Key-pair created in OpenStack](https://github.com/naturalis/openstack-docs/wiki/Howto:-Creating-and-using-OpenStack-SSH-keypairs-on-Linux-and-OSX)
* Docker installed (`yum install -y docker` on RHEL/Centos, `dnf install docker -y` on Fedora)
  * If you plan to run docker as yourself (non-root), your username must be added to the `docker` user group.
* An `~/.ansible.cfg` file containing the following:
```
[defaults]
roles_path=/root/code/casl-ansible/roles:/root/code/openshift-ansible/roles
filter_plugins= /usr/share/ansible_plugins/filter_plugins:/root/code/openshift-ansible/filter_plugins
host_key_checking = False
```
* Clone this, and dependent `openshift-ansible` repositories into the same directory
```
cd ~/src/
git clone git@github.com:redhat-cop/casl-ansible.git
```
* Copy `casl-ansible/inventory/sample.casl.example.com.d/inventory/clouds.yaml` to `~/.config/openstack/clouds.yaml`

* Download/untar `openshift-ansible` for use as part of the install. Make sure to do so within the same directory as above (i.e.: `~/src`), and either rename the directory to `openshift-ansible` or create symlink to it (see example below). See table below for versions / urls to be used for the download. Note that other versions may work as well, but these are the ones we have tested and found to be stable. Feel free to submit PRs with updated versions as they are found to be functional. 

(*hint* right-click the `openshift-ansible` version number in the table below and copy the URL)

```
wget <url> -O - | tar -xz
ln -fs openshift-ansible-*<version>* openshift-ansible
```

| openshift-ansible url     | OpenShift version | 
|:-------------------------:|:-----------------:|
| [3.4.50-1](https://github.com/openshift/openshift-ansible/archive/openshift-ansible-3.4.60-1.tar.gz) | OCP 3.4 |

Cool! Now you're ready to provision OpenShift clusters

### Provision a Cluster

To start, we'll provision the `sample.casl.example.com` cluster defined in the `casl-ansible/inventory` directory. 

**Note**: *It is recommended that you use a different inventory by duplicating the `sample.casl.example.com.d` directory and keep it elsewhere. In that way, you can update/remove/change your casl-ansble directory without losing your inventory. It may take some time to get the inventory just right, hence it is very beneficial to keep it around for future use without having to redo everything.*

The following is just an example on how the `sample.casl.example.com` inventory can be used:

1) Edit `casl-ansible/inventory/sample.casl.example.com.d/inventory/hosts` and edit the `# OpenStack Provisioning Variables` and `# Subscription Management` sections at the top to match your environment/project/tenant. See comments in the file for more detailed information on how to fill these in.

2) Start the `openstack-client` container.
```
cd ~/src/casl-ansible/docker/control-host-openstack
docker-compose up -d
docker exec -it <container-name> bash
```

**Note**: If you see an error saying that there are no `config/*.sh` files, try
temporarily disabling SELinux (`sudo setenforce 0`) and running a new
container.

3) Run the `end-to-end` provisioning playbook
```
ansible-playbook -i /root/code/casl-ansible/inventory/sample.casl.example.com.d/inventory /root/code/casl-ansible/playbooks/openshift/end-to-end.yml -e openstack_ssh_public_key=<your_ssh_key_name>
```

The `openstack_ssh_public_key` variable at the end should specify the name of your OpenStack keypair (`openstack keypair list`).

### Updating a Cluster

Once provisioned, a cluster may be adjusted/reconfigured as needed by updating inventory and re-running the `end-to-end.yml` playbook.

### Scaling Up and Down

A cluster's Infra and App nodes may be scaled up and down by editing the following parameters in the `hosts` or `all.yml` files

```
openstack_num_nodes=1
openstack_num_infra=1
```

and then re-running the playbook.

```
ansible-playbook -i /root/code/casl-ansible/inventory/sample.casl.example.com.d/inventory /root/code/casl-ansible/playbooks/openshift/end-to-end.yml
```

