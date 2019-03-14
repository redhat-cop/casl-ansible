# Overview
This role allows you to set labels on objects in OpenShift

## Usage:
```
tasks:
- include_role:
    name: roles/openshift-labels
  vars:
    label: "app=myawesomeapp"
    target_object: <Resource Type, e.g. DeploymentConfig/Secret/Pod/etc...>
    target_name: <Resource Name>
    target_namespace: <Project Name>  # Optional
```
When the `target_namespace` is ommitted, the current oc client namespace is used.

