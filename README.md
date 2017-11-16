#  CASL Ansible

Automation of OpenShift using [Ansible](http://www.ansible.com/).
(This includes automation of OpenShift Cluster provisioning as well as other automation tasks post-provisioning.)

## Provisioning (Quickstart)

### Local Setup (one time, only)

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

* Download/untar `openshift-ansible` for use as part of the install. Make sure to do so within the same directory as above (i.e.: `~/src`), and either rename the directory to `openshift-ansible` (or create symlink to it - see example below). See table below for versions / urls to be used for the download.

> **_hint_** right-click the `openshift-ansible` version number in the table below and copy the URL

```
cd ~/src/
wget <url> -O - | tar -xz
ln -fs openshift-ansible-*<version>* openshift-ansible
```

Below is a list of versions the CASL team has leveraged and found to be stable/working. Note that other versions may work as well. Feel free to submit PRs for this file with updated versions as they are found to be functional.

| openshift-ansible url     | OpenShift version |
|:-------------------------:|:-----------------:|
| [3.6.173.0.45-1](https://github.com/openshift/openshift-ansible/archive/openshift-ansible-3.6.173.0.41-1.tar.gz) | OCP 3.6.x |
| [3.5.77-1](https://github.com/openshift/openshift-ansible/archive/openshift-ansible-3.5.77-1.tar.gz) | OCP 3.5.x |
| [3.4.50-1](https://github.com/openshift/openshift-ansible/archive/openshift-ansible-3.4.60-1.tar.gz) | OCP 3.4 |

* Run `ansible-galaxy` to pull in the necssary requirements for the CASL provisioning:

```
cd ~/src/casl-ansible
ansible-galaxy install -r casl-requirements.yml -p roles
```

#### OpenStack specific requirements
* Access to an OpenStack environment using an [OpenStack RC File](https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/11/html/command-line_interface_reference/ch_cli#cli_openrc)
  * File should be placed at `~/.config/openstack/openrc.sh`
>**NOTE:** OpenStack environment requires Heat to be enabled, and the user must have the `heat_stack_owner` role assigned.
* A [Key-pair created or imported in OpenStack](https://github.com/naturalis/openstack-docs/wiki/Howto:-Creating-and-using-OpenStack-SSH-keypairs-on-Linux-and-OSX)
* Copy `~/src/casl-ansible/inventory/sample.casl.example.com.d/inventory/clouds.yaml` to `~/.config/openstack/clouds.yaml`

#### AWS specific requirements
* Requirements to use the AWS provision can be found in the Role's [README](roles/manage-aws-infra/README.md)
* A [Key-pair created or imported in AWS](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair)
* Modify 'regions' entry (line 13) from 'ec2.ini' file in your environment to match the 'aws_region' variable in your inventory
* Modify 'instance_filters' entry (line 14) from 'ec2.ini' file in your environment to match the 'env_id' variable in your inventory


Cool! Now you're ready to provision OpenShift clusters on OpenStack and AWS

### Provision a Cluster

To start, we'll provision the `sample.casl.example.com` cluster defined in the `~/src/casl-ansible/inventory` directory.

> **Note**: *It is recommended that you use a different inventory by duplicating the `sample.casl.example.com.d` directory and keep it elsewhere. This allows you to update/remove/change your casl-ansble source directory without losing your inventory. It may take some effort to get the inventory just right, hence it is very beneficial to keep it around for future use without having to redo everything.*

The following is just an example on how the `sample.casl.example.com` inventory can be used:

1) Edit `~/src/casl-ansible/inventory/sample.casl.example.com.d/inventory/hosts` to match your environment/project/tenant. See comments in the file for more detailed information on how to fill these in.

2) Edit `~/src/casl-ansible/inventory/sample.casl.example.com.d/inventory/group_vars/all.yml` to match your cloud provider/environment/project/tenant. See comments in the file for more detailed information on how to fill these in.

3) Edit `~/src/casl-ansible/inventory/sample.casl.example.com.d/inventory/group_vars/OSEv3.yml` for your OpenShift specific configuration. See comments in the file for more detailed information on how to fill these in.

4) (optional) Set environment variables to match your environment for the Control Host - more details in the [Control Host README](https://github.com/redhat-cop/casl-ansible/blob/master/docker/control-host-openstack/README.md#environment-variables).

5) Start the `control-host-openstack` container.
```
cd ~/src/casl-ansible/docker/control-host-openstack
docker-compose up -d
docker exec -it <container-name> bash
```

> **Note 1:** The `docker-compose` step above is only required to do once. More details can be found in the [Control Host README](https://github.com/redhat-cop/casl-ansible/blob/master/docker/control-host-openstack/README.md).

> **Note 2:** If you see an error saying that there are no `config/*.sh` files, try temporarily disabling SELinux (`sudo setenforce 0`) and running a new container.

6) Run the `end-to-end` provisioning playbook
```
ansible-playbook -i <inventory> /root/code/casl-ansible/playbooks/openshift/end-to-end.yml [-e openstack_ssh_public_key=<your_ssh_key_name>]
```

> **Note 1:** Where `<inventory>` is the path to your inventory directory as mentioned above.

> **Note 2:** The `openstack_ssh_public_key` is applicable for OpenStack deployments only and should be set to the name of your OpenStack keypair already configured within the environment.

> **Note 3:** You may need to add the `--private-key` option to the playbook execution, depending on your Ansible/inventory configuration or if the default `id_rsa` isn't the key used.


Done! Wait till the provisioning completes and you should have an operational cluster. If something fails along the way, either update your inventory and re-run the above `end-to-end.yml` playbook, or it may be better to [delete the cluster](https://github.com/redhat-cop/casl-ansible#deleting-a-cluster) and re-start.

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
### Start/Stop  a Cluster

In the case we are using a Cloud Provider (AWS) to run the Cluster, it may be interesting to stop/start the instances where the Cluster is running in order to reduce costs. To do so, two playbooks are available, `start-cluster.yml` and `stop-cluster.yml`, re-using the same inventory:

```
ansible-playbook -i /root/code/casl-ansible/inventory/ample.aws.example.com.d/inventory /root/code/casl-ansible/playbooks/openshift/start-cluster.yml
```
```
ansible-playbook -i /root/code/casl-ansible/inventory/ample.aws.example.com.d/inventory /root/code/casl-ansible/playbooks/openshift/stop-cluster.yml
```

### Deleting a Cluster

A cluster can be decommissioned/deleted by re-using the same inventory with the `delete-cluster.yml` playbook

```
ansible-playbook -i /root/code/casl-ansible/inventory/sample.casl.example.com.d/inventory /root/code/casl-ansible/playbooks/openshift/delete-cluster.yml
```

> **AWS Specific:** While deleting an AWS Cluster, the **delete_vpc** variable must be provided in order to remove or not the VPC the Cluster belongs to. Check role [README](roles/manage-aws-infra/README.md) for further information.
