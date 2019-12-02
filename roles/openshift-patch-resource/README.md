openshift-patch-resource
========================

Patch a Kubernetes/Openshift resource

Requirements
------------

This role requires the `kubernetes` python module and an active session to your Kubernetes/Openshift cluster.

Role Variables
--------------

| Variable | Description | Required | Defaults |
| :------- | :---------- | :------- | :------- |
| api_version | The api_version of the resource | yes ||
| definition | The patch definition | yes ||
| kind | The kind of the resource | yes ||
| merge_type | A list of merge types ("strategic-merge, merge") | no | [strategic-merge](https://docs.ansible.com/ansible/latest/modules/k8s_module.html) |
| name | The name of the resource | yes ||
| namespace | The namespace of the resource | no ||

Example Playbook
----------------

```yaml
---
- hosts: localhost
  tasks:
    - name: Patch annotations on default project (strategic-merge strategy)
      include_role:
        name: openshift-patch-resource
      vars:
        api_version: v1
        definition:
          metadata:
            labels:
              patch-role: patched
        kind: Namespace
        merge_type: strategic-merge
        name: default
    - name: Get annotated namespace
      k8s_info:
        kind: Namespace
        label_selectors:
          - patch-role=patched
      register: r_namespace_label
    - name: Assert namespace was labelled
      assert:
        that:
          - (r_namespace_label.resources | length) == 1
          - "'patched' in r_namespace_label.resources[0].metadata.labels['patch-role']"
        fail_msg: "Expected one namespace with the label 'patch-role: patched'"
        success_msg: "There's one namespace with the label 'patch-role: patched'"
    - name: Remove patch-role label (merge strategy)
      include_role:
        name: openshift-patch-resource
      vars:
        api_version: v1
        definition:
          metadata:
            labels:
              patch-role: null
        kind: Namespace
        merge_type: merge
        name: default
    - name: Get annotated namespace
      k8s_info:
        kind: Namespace
        label_selectors:
          - patch-role=patched
      register: r_namespace
    - name: Assert namespace label was removed
      assert:
        that:
          - (r_namespace.resources | length) == 0
        fail_msg: "Expected zero namespace with the label 'patch-role: patched'"
        success_msg: "There's no namespace with the label 'patch-role: patched'"
```

License
-------

Apache 2.0

Author Information
------------------

Red Hat Community of Practice & staff of the Red Hat Open Innovation Labs.
