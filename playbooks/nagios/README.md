# Nagios Example Run

The `nagios-target` and `nagios-server` roles can be used to setup a complete Nagios monitoring for any environment. The `nagios-target` role will prepare the targets with the correct monitoring configuratoin for use with the NRPE (Nagios Remote Plugin Executor). The target role will selectively enable the correct monitoring plugins (and correctly configured) per targets.

Below is an example inventory file for setting up the Nagios server and targets. Before executing, ensure that access to the target servers is enabled - i.e.: SSH key login for root. 

Example run of the playbook:
> ansible-playbook -i \<path_to_inventory\> setup_nagios.yml


```
[all:vars]
ansible_ssh_user=root

# Infrastructure Server
[infra]
dns.infra.example.com nagios_services=dns
nfs.infra.example.com nagios_services=nfs

[infra:vars]
hostgroup_name=infra-servers
hostgroup_alias=Infrastructure Servers

# OpenShift 3 environment
[openshift]
master.openshift.example.com nagios_services=docker,openshift-master,openshift-node
node1.openshift.example.com nagios_services=docker,openshift-node
node2.openshift.example.com nagios_services=docker,openshift-node
node3.openshift.example.com nagios_services=docker,openshift-node
dns.openshift.example.com nagios_services=dns
nfs.openshift.example.com nagios_services=nfs

[openshift:vars]
hostgroup_name=openshift-cluster
hostgroup_alias=OpenShift Cluster (Environment #2)


###############################################################################
# The 'nagios-targets' definition is required
[nagios-targets:children]
infra
openshift

# The 'nagios-servers' definition is required
[nagios-servers]
nagios.example.com
```


