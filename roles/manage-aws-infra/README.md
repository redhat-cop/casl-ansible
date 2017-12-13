manage-aws-infra
================

This role deploys and manages the underlying OCP required Infrastructure in AWS based in the variables defined in the inventory.

As this is a shared environment, specific tags not related to OCP are added as well to every ec2 and ebs created objects so they can be easily identified. These can be found and modified under 'instance_tags' option on every ec2 instance creation.

Requirements
------------

Ansible version >= 2.4

Role Variables
--------------

| Variable        | Description                           |
|:---------------:|:-------------------------------------:|
|**aws_image_name**| aws ec2 AMI ID
|**aws_num_masters**| number of OCP Master instances to be deployed
|**aws_num_nodes**| number of OCP Compute Node instances to be deployed
|**aws_num_infra**| number of OCP Infra Node instances to be deployed
|**aws_access_key**| aws access key from AWS_ACCESS_KEY_ID environment variable
|**aws_secret_key**| aws Secret access key from AWS_SECRET_ACCESS_KEY environment variable
|**aws_region**| aws Region where to deploy the Infrastructure
|**aws_key_name**| aws Key pair name to be used with the instances
|**aws_subnet**| aws Subnet ID (this value is ignored in case 'aws_create_vpc: true')
|**aws_create_vpc**| either to create the VPC to be used by the OCP Infrastructure &#45; true &#124; false
|**aws_master_sgroups**| aws security groups assigned to Master instances
|**aws_infra_sgroups**| aws security groups assigned to Infra Node instances
|**aws_node_sgroups**| aws security groups assigned to Compute Node instances
|**master_flavor**| ec2 flavor to be used with master instances
|**infra_flavor**| ec2 flavor to be used with infra instances
|**node_flavor**| ec2 flavor to be used with compute instances
|**gluster_flavor**| ec2 flavor to be used with gluster instances
|**master_tag**| tag to be assigned to master instances
|**etcd_tag**| tag to be assigned to etcd instances
|**infranode_tag**| tag to be assigned to infra instances
|**computenode_tag**| tag to be assigned to compute instances
|**user_tag**| specific tag to identify same user's instances
|**role_tag**| specific tag to identify same role instances
|**group_masters_tag**| tag to create ec2 groups for masters to be used in the inventory
|**group_infra_tag**| tag to create ec2 groups for infra nodes to be used in the inventory
|**group_compute_tag**| tag to create ec2 groups for compute nodes to be used in the inventory
|**labels_master_tag**| tag to feed master node labels in OCP
|**labels_infra_tag**| tag to feed infra node labels in OCP
|**label_compute_tag**| tag to feed compute node labels in OCP
|**instances_termination_protection**| boolean to protect instances to be terminated accidentally
|**master_root_volume_size**| size in Gi for the / File System
|**infra_root_volume_size**| size in Gi for the / File System
|**node_root_volume_size**| size in Gi for the / File System
|**gluster_root_volume_size**| size in Gi for the / File System
|**env_id**| environment ID to use for the Cluster
|**public_dns_domain**| public DNS Zone where to register de Cluster
|**ha_mode**| either to create an HA Cluster or not &#45; true &#124; false
|**delete_vpc**| boolean to remove or not the VPC used for the Cluster &#45; true &#124; false|
