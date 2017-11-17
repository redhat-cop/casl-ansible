# Provisioning an OpenShift Cluster using the CASL Tools

## Local Setup (one time, only)

> **NOTE:** These steps are a canned set of steps serving as an example, and may be different in your environment.

In addition to _cloning this repo_, you'll need the following:

* Access to a Cloud Provider (OpenStack supported for the time being)
* Docker installed
  * RHEL/CentOS: `yum install -y docker`
  * Fedora: `dnf install -y docker`
  * **NOTE:** If you plan to run docker as yourself (non-root), your username must be added to the `docker` user group.
* Specific Cloud Provider requirements (see below).
* Clone this repository (make sure to adjust paths as fit for your local environment - in this case `~/src` is used):

```
cd ~/src/
git clone https://github.com/redhat-cop/casl-ansible.git
```

* Download/untar `openshift-ansible` for use as part of the install. Make sure to do so within the same directory as above (i.e.: `~/src`), and either rename the directory to `openshift-ansible` (or create symlink to it - see example below). See our [Compatibility Matrix](./README.md#compatability-matrix) for versions / urls to be used for the download.

```
cd ~/src/
wget <url> -O - | tar -xz
ln -fs openshift-ansible-*<version>* openshift-ansible
```

* Run `ansible-galaxy` to pull in the necssary requirements for the CASL provisioning:

```
cd ~/src/casl-ansible
ansible-galaxy install -r casl-requirements.yml -p roles
```

### OpenStack specific requirements
* Access to an OpenStack environment using an [OpenStack RC File](https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/11/html/command-line_interface_reference/ch_cli#cli_openrc)
  * File should be placed at `~/.config/openstack/openrc.sh`
>**NOTE:** OpenStack environment requires Heat to be enabled, and the user must have the `heat_stack_owner` role assigned.
* A [Key-pair created or imported in OpenStack](https://github.com/naturalis/openstack-docs/wiki/Howto:-Creating-and-using-OpenStack-SSH-keypairs-on-Linux-and-OSX)
* Copy `~/src/casl-ansible/inventory/sample.casl.example.com.d/inventory/clouds.yaml` to `~/.config/openstack/clouds.yaml`

Cool! Now you're ready to provision OpenShift clusters on OpenStack

## Provision a Cluster

To start, we'll provision the `sample.casl.example.com` cluster defined in the `~/src/casl-ansible/inventory` directory.

> **Note**: *It is recommended that you use a different inventory by duplicating the `sample.casl.example.com.d` directory and keep it elsewhere. This allows you to update/remove/change your casl-ansble source directory without losing your inventory. It may take some effort to get the inventory just right, hence it is very beneficial to keep it around for future use without having to redo everything.*

The following is just an example on how the `sample.casl.example.com` inventory can be used:

1) Edit `~/src/casl-ansible/inventory/sample.casl.example.com.d/inventory/hosts` to match your environment/project/tenant. See comments in the file for more detailed information on how to fill these in.

2) Edit `~/src/casl-ansible/inventory/sample.casl.example.com.d/inventory/group_vars/all.yml` to match your cloud provider/environment/project/tenant. See comments in the file for more detailed information on how to fill these in.

3) Edit `~/src/casl-ansible/inventory/sample.casl.example.com.d/inventory/group_vars/OSEv3.yml` for your OpenShift specific configuration. See comments in the file for more detailed information on how to fill these in.

4) Create public and private DNS Zones. (more instructions coming soon)

6) Run the `end-to-end` provisioning playbook via our [openstack installer container image](/images/installer-openstack/).
```
docker run -u `id -u` \
      -v $HOME/.ssh/id_rsa:/opt/app-root/src/.ssh/id_rsa:Z \
      -v $HOME/src/:/tmp/src:Z \
      -v $HOME/.config/openstack/:/opt/app-root/src/.config/openstack/ \
      -e INVENTORY_DIR=/tmp/src/casl-ansible/inventory/sample.casl.example.com.d/inventory \
      -e PLAYBOOK_FILE=/tmp/src/casl-ansible/playbooks/openshift/end-to-end.yml \
      -e OPTS="-e openstack_ssh_public_key=my-key-name" -t \
      redhatcop/installer-openstack
```

NOTE: The `openstack_ssh_public_key` variable at the end should specify the name of your OpenStack keypair (`openstack keypair list`).

Done! Wait till the provisioning completes and you should have an operational cluster. If something fails along the way, either update your inventory and re-run the above `end-to-end.yml` playbook, or it may be better to [delete the cluster](https://github.com/redhat-cop/casl-ansible#deleting-a-cluster) and re-start.

## Updating a Cluster

Once provisioned, a cluster may be adjusted/reconfigured as needed by updating inventory and re-running the `end-to-end.yml` playbook.

## Scaling Up and Down

A cluster's Infra and App nodes may be scaled up and down by editing the following parameters in the `hosts` or `all.yml` files

```
openstack_num_nodes=1
openstack_num_infra=1
```

and then re-running the playbook.

```
ansible-playbook -i /root/code/casl-ansible/inventory/sample.casl.example.com.d/inventory /root/code/casl-ansible/playbooks/openshift/end-to-end.yml
```

## Deleting a Cluster

A cluster can be decommissioned/deleted by re-using the same inventory with the `delete-cluster.yml` playbook

```
ansible-playbook -i /root/code/casl-ansible/inventory/sample.casl.example.com.d/inventory /root/code/casl-ansible/playbooks/openshift/delete-cluster.yml
```
