openshift-applier
=================

Role used to apply OpenShift objects to an existing OpenShift Cluster.


Requirements
------------
A working OpenShift cluster that can be used to populate things like namespaces, policies and PVs (all require cluster-admin), or application level content.


Role Variables
--------------

#### Sourcing OpenShift Object Definitions

The variable definitions come in the form of an object, `openshift_cluster_content`, which contains sub-objects containing file, template, and parameter definitions. At its simplest, this definition looks like this:
 
```yaml
openshift_cluster_content:
- object: <object_type>
  content:
  - name: <definition_name>
    file: <file source>
- object: <object_type>
  content:
  - name: <definition_name>
    template: <template_source>
    params: <params_file_source>
    namespace: <target_openshift_namespace>
```

You have the choice of sourcing a `file` or a `template`. The `file` definition expects that the sourced file has all definitions set and will NOT accept any parameters (i.e.: static content). The `template` definition expects a `params` file to be sourced along with it which will be passed into the template.

**_TIP:_** Both choices give you the option of defining target namespaces in the template manually, or adding the `namespace` variable alongside the template and params (where applicable)

#### Sourcing a directory with files

You can source a directory composed of static files (without parameters) using `content_dir` instead of defining each file individually. That would look like this:
```yaml
- object: policy
  content_dir: <dir_with_policy_files>
```
In this example above, all of the files in the `<dir_with_policy_files>` directory would get sourced and applied to the cluster (native OpenShift processing).

### Ordering of Objects in the inventory

The inventory content is defined as an ordered list, and hence processed in the order it is written. This is important to understand from the perspective of dependencies between your inventory content. For example; it's important to have namespaces or projectrequests defined early to ensure these exists before any of the builds or deployments defined later on in the inventory attempts to use a namespace.

One of the ways to define an OpenShift project using a file or template is to use define a `namespace` object. It would look like this:
```yaml
- object: namespace
  content:
  - name: <namespace_name>
    file: <file_source>
```

### Privileged Objects 

Note that the `openshift-applier` runs at the permission level a user has, and hence defining objects requiring elevated privileges also requires the user running the `openshift-applier` to have the same level (or higher) of access to the OpenShift cluster.

### Object Entries in the Inventory

Objects and entries can be named as you please. In these objects definitions, you source templates that will add any in-project OpenShift objects including buildconfigs, deploymentconfigs, services, routes, etc. (*note:* these are standard OpenShift templates and no limitations is imposed from the `openshift-applier` for this content). 

You can source as many templates and static files as you like.

These objects look like this:
```yaml
- object: <relevant_name>
  content:
  - name: <name_of_first_template>
    template: <template_source>
    params: <params_file_source>
    namespace: <target_namespace>
  - name: <name_of_second_template>
    template: <template_source>
    params: <params_file_source>
    namespace: <target_namespace>
  - name: <name_of_second_template>
    file: <yaml/json_source>
    namespace: <target_namespace>
- object: <relevant_name>
  content:
  - name: <name_of_another_template>
    template: <template_source>
    params: <params_file_source>
    namespace: <target_namespace>
```

**_NOTE:_** The objects are sourced and applied in the order found in the list. For objects with inter-dependencies, it is important to consider the order these are defined. 

**_NOTE:_** If the target namespace is not defined in each of the objects within the template, be sure to add the `namespace` variable. 


Dependencies
------------
- openshift-login: Ansible role used to login a user to the OpenShift cluster.


Example Playbook
----------------

TBD

License
-------

BSD

Author Information
------------------
Red Hat Community of Practice & staff of the Red Hat Open Innovation Labs.
