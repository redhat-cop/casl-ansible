# The CASL Ansible playbooks

## openshift-cluster-seed.yml (openshift-applier)
This playbook is mainly here to serve as the execution point for the [openshift-applier](https://github.com/redhat-cop/casl-ansible/tree/master/roles/openshift-applier). There are few important notes to make about how this is executed:

1. Inventory
To better integrate with other tools leveraging this playbook, the `hosts` have been defined as `seed-hosts`. This means that the inventory needs to contain a valid group for `seed-hosts`, such as:

```
[seed-hosts]
localhost
```

2. Local Execution
If the playbook is executed locally, i.e.: on your `localhost`, it's recommended to run with the local option to speed up the execution. This prevents the inventory from being copied to the remote host (even if the remote host is your localhost) and hence avoids the extra time it takes to iterate over the inventory content to copy the local files.

```
--connection=local
```

