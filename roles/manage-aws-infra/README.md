manage-aws-infra
================

This role deploys and manages the underlying OCP required Infrastructure in AWS based in the variables defined in the inventory.

As this is a shared environment, specific tags not related to OCP are added as well to every ec2 and ebs created objects so they can be easily identified. These can be found and modified under 'instance_tags' option on every ec2 instance creation.

Requirements
------------

Ansible version >= 2.4

Role Variables
--------------

The majority of the variables required to use the role are defined under the **cloud_infrastructure** object. This object definition is the representation for the underlaying infrastructure and all the required components to deploy an OpenShift Cluster on top of it.

Many of these required variables have default values. These are the **mandatory** variables you need to specify in order the role to work.

Infrastructure skeleton variables
---------------------------------

```yaml
cloud_infrastructure: **mandatory**
   region: **mandatory**
   image_name: **mandatory**
   masters: **mandatory**
     count: **defaulted**
     flavor: **defaulted**
     zones:
     - **at least 1 zone specification is mandatory**
     name_prefix: **defaulted**
     root_volume_size: **defaulted**
     docker_volume_size: **defaulted**
   etcdnodes: **not mandatory when deploying embedded etcd**
     count: **defaulted**
     flavor: **defaulted**
     zones:
     - **at least 1 zone specification is mandatory when NOT deploying embedded etcd**
     name_prefix: **defaulted**
     root_volume_size: **defaulted**
     docker_volume_size:**defaulted**
   appnodes: **mandatory**
     count: **defaulted**
     flavor: **defaulted**
     zones:
     - **at least 1 zone specification is mandatory**
     name_prefix: **defaulted**
     root_volume_size: **defaulted**
     docker_volume_size: **defaulted**
   infranodes: **mandatory**
     count: **defaulted**
     flavor: **defaulted**
     zones:
     - **at least 1 zone specification is mandatory**
     name_prefix: **defaulted**
     root_volume_size: **defaulted**
     docker_volume_size: **defaulted**
   cnsnodes: **not mandatory when CNS is not required**
     count: **mandatory when using CNS and with a fixed value of 3. If not using CNS this is defaulted to 0**
     flavor: **defaulted**
     zones:
     - **at least 1 zone specification is mandatory when using CNS**
     name_prefix: **defaulted**
     root_volume_size: **defaulted**
     docker_volume_size: **defaulted**
     gluster_volume_size: **defaulted**
```

Other variables
---------------

| Variable        | Description                           |
|:---------------:|:-------------------------------------:|
|**aws_access_key**| aws access key from AWS_ACCESS_KEY_ID environment variable
|**aws_secret_key**| aws Secret access key from AWS_SECRET_ACCESS_KEY environment variable
|**aws_key_name**| aws Key pair name to be used with the instances
|**group_masters_tag**| tag to create ec2 groups for master nodes to be used in the inventory
|**group_masters_etcd_tag**| tag to create ec2 groups for etcd embedded nodes to be used in the inventory
|**group_etcd_nodes_tag**| tag to create ec2 groups for etcd nodes to be used in the inventory
|**group_infra_nodes_tag**| tag to create ec2 groups for infra nodes to be used in the inventory
|**group_app_nodes_tag**| tag to create ec2 groups for compute nodes to be used in the inventory
|**group_cns_nodes_tag**| tag to create ec2 groups for CNS nodes to be used in the inventory
|**labels_masters_tag**| tag to feed master node labels in OCP
|**labels_etcd_nodes_tag**| tag to feed etcd node labels in OCP
|**labels_infra_nodes_tag**| tag to feed infra node labels in OCP
|**labels_app_nodes_tag**| tag to feed compute node labels in OCP
|**labels_cns_nodes_tag**| tag to feed CNS node labels in OCP
|**env_id**| environment ID to use for the Cluster
|**public_dns_domain**| public DNS Zone where to register de Cluster
