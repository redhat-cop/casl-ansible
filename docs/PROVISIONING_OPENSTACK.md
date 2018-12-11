# OpenShift on OpenStack using CASL

## Local Setup (one time, only)

> **NOTE:** These steps are a canned set of steps serving as an example, and may be different in your environment.

In addition to _cloning this repo_, you'll need the following:

* Access to a OpenStack Cluster (see details below)
* Docker installed
  * RHEL/CentOS: `yum install -y docker`
  * Fedora: `dnf install -y docker`
  * **NOTE:** If you plan to run docker as yourself (non-root), your username must be added to the `docker` user group.

```
cd ~/src/
git clone https://github.com/redhat-cop/casl-ansible.git
```

* Run `ansible-galaxy` to pull in the necessary requirements for the CASL provisioning of OpenShift on OpenStack:

> **NOTE:** The target directory ( `galaxy` ) is **important** as the playbooks know to source roles and playbooks from that location.

```
cd ~/src/casl-ansible
ansible-galaxy install -r casl-requirements.yml -p galaxy
```

## OpenStack specific requirements
* Access to an OpenStack environment using an [OpenStack RC File](https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/11/html/command-line_interface_reference/ch_cli#cli_openrc)
  * Unless you have specific requirements, the file should be placed at `~/.config/openstack/openrc.sh`
>**NOTE:** OpenStack environment requires Heat to be enabled, and the user must have the `heat_stack_owner` role assigned.
* A [Key-pair in OpenStack](https://github.com/naturalis/openstack-docs/wiki/Howto:-Creating-and-using-OpenStack-SSH-keypairs-on-Linux-and-OSX)
* Copy `~/src/casl-ansible/inventory/sample.osp.example.com.d/inventory/clouds.yaml` to `~/.config/openstack/clouds.yaml`

Cool! Now you're ready to provision OpenShift clusters on OpenStack

## Provision an OpenShift Cluster

As an example, we'll provision the `sample.osp.example.com` cluster defined in the `~/src/casl-ansible/inventory` directory.

> **Note**: *It is recommended that you use a different inventory similar to the ones found in the `~src/casl-ansible/inventory` directory and keep it elsewhere. This allows you to update/remove/change your casl-ansble source directory without losing your inventory. Also note that it may take some effort to get the inventory just right, hence it is very beneficial to keep it around for future use without having to redo everything.*

The following is just an example on how the `sample.osp.example.com` inventory can be used:

1) Edit `~/src/casl-ansible/inventory/sample.osp.example.com.d/inventory/hosts` to match your environment/project/tenant. See comments in the file for more detailed information on how to fill these in.

2) Edit `~/src/casl-ansible/inventory/sample.osp.example.com.d/inventory/group_vars/all.yml` to match your cloud provider/environment/project/tenant. See comments in the file for more detailed information on how to fill these in. To utilize an automatic provisioned OSP cinder volume for the registry add the following to `all.yml`
```
openshift_hosted_registry_storage_kind: openstack
#openshift_hosted_registry_storage_volume_size: 20
```

**Note1**: `openshift_hosted_registry_storage_volume_size` is used to define a specific registry size but is optional and defaults to 20GB if not defined.

**Note2**: `openshift_hosted_registry_storage_volume_size` should be specified *without* the Unit (i.e.: `Gi`) as the tools expects the value to specified as an integer. 

3) Edit `~/src/casl-ansible/inventory/sample.osp.example.com.d/inventory/group_vars/OSEv3.yml` for your OpenShift specific configuration. See comments in the file for more detailed information on how to fill these in.

4) Create public and private DNS Zones. (more instructions coming soon)

5) Run the `end-to-end` provisioning playbook via our [OpenStack installer container image](../images/casl-ansible/).

```
docker run -u `id -u` \
      -v $HOME/.ssh/id_rsa:/opt/app-root/src/.ssh/id_rsa:Z \
      -v $HOME/src/:/tmp/src:Z \
      -v $HOME/.config/openstack/:/opt/app-root/src/.config/openstack/ \
      -e INVENTORY_DIR=/tmp/src/casl-ansible/inventory/sample.osp.example.com.d/inventory \
      -e PLAYBOOK_FILE=/tmp/src/casl-ansible/playbooks/openshift/end-to-end.yml \
      -e OPTS="-e openstack_ssh_public_key=my-key-name" -t \
      quay.io/redhat-cop/casl-ansible
```

> **Note 1:** The `openstack_ssh_public_key` variable at the end should specify the name of your OpenStack keypair - as noted under OpenStack Specific Requirements above (Obtain name from the OpenStack web console or use the `openstack keypair list` CLI command).

> **Note 2:** The above bind-mounts will map files and source directories to the correct locations within the control host container. Update the local paths per your environment for a successful run.

Done! Wait till the provisioning completes and you should have an operational OpenShift cluster. If something fails along the way, either update your inventory and re-run the above `end-to-end.yml` playbook, or it may be better to [delete the cluster](https://github.com/redhat-cop/casl-ansible#deleting-a-cluster) and re-start.

## Updating a Cluster

Once provisioned, a cluster may be adjusted/reconfigured as needed by updating the inventory and re-running the `end-to-end.yml` playbook.

## Scaling Up and Down

A cluster's Infra and App nodes may be scaled up and down by editing the following parameters in the `hosts` or `all.yml` file and then re-running the `end-to-end.yml` playbook as shown above.

```
openstack_num_nodes=X
openstack_num_infra=Y
```

## Deleting a Cluster

A cluster can be decommissioned/deleted by re-using the same inventory with the `delete-cluster.yml` playbook found alongside the `end-to-end.yml` playbook.

```
docker run -u `id -u` \
      -v $HOME/.ssh/id_rsa:/opt/app-root/src/.ssh/id_rsa:Z \
      -v $HOME/src/:/tmp/src:Z \
      -v $HOME/.config/openstack/:/opt/app-root/src/.config/openstack/ \
      -e INVENTORY_DIR=/tmp/src/casl-ansible/inventory/sample.osp.example.com.d/inventory \
      -e PLAYBOOK_FILE=/tmp/src/casl-ansible/playbooks/openshift/delete-cluster.yml \
      quay.io/redhat-cop/casl-ansible
```
