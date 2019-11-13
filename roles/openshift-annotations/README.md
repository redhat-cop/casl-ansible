# Overview
This role allows you to set annotations on objects in OpenShift

## Usage:
```
tasks:
- include_role:
    name: roles/openshift-annotations
  vars:
    annotation: "app=myawesomeapp"
    target_object: <Resource Type, e.g. DeploymentConfig/Secret/Pod/etc...>
    target_name: <Resource Name>
    target_namespace: <Project Name>  # Optional
```
When the `target_namespace` is ommitted, the current oc client namespace is used.

This role can apply multiple annotations to an object at the same time. This can be done by providing a space delimted string of annotations.

## Examples

### Single Annotation

```yaml
- include_role:
    name: roles/openshift-annotations
  vars:
    annotation: "app=myawesomeapp"
    target_object: "service"
    target_name: "my-app-ui"
    target_namespace: "my-awesome-web-app"
```


### Multiple Annotations

```yaml
- include_role:
    name: roles/openshift-annotations
  vars:
    annotation: "app=myawesomeapp region=east env=dev"
    target_object: "service"
    target_name: "my-app-ui"
    target_namespace: "my-awesome-web-app"
```
