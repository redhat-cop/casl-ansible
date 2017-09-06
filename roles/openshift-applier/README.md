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

You have the choice of sourcing a `file` or a `template`. The `file` definition expects that the sourced file has all definitions set and will not pass any parameters (i.e.: static content). The `template` definition expects a `params` file to be sourced along with it which will be passed into the template.

Both choices give you the option of defining target namespaces in the template manually, or adding the `namespace` variable alongside the template and params (where applicable)

#### Sourcing a directory with files

You can source a directory composed of files (without parameters) using `content_dir` instead of defining each file individually. That would look like this:
```yaml
- object: policy
  content_dir: <dir_with_policy_files>
```
In this example above, all of the files in the `<dir_with_policy_files>` directory would get sourced and applied to the cluster.

### namespace objects (cluster-admin only)

One of the ways to define an OpenShift project using a file or template is to use define a `namespace` object. It would look like this:
```yaml
- object: namespace
  content:
  - name: <namespace_name>
    file: <file_source>
```

If you need to add any cluster-admin level objects in the template, then using the `namespace` object is the way to go. Otherwise, it is best to use the `projectrequest` object so that any user with the ability to create projects is able to run it. 

**_NOTE:_** Since the file sourced by the namespace object is going to create the namespace, do not add the `namespace` variable to this object definition.

### projectrequest objects

The other way to create an OpenShift project using a file is to use the `projectrequest` object. This is the preferred object-type for creating OpenShift projects as it doesn't require elevated privileges (such as *cluster-admin* ) to be applied. The object would look like this:
```yaml
- object: projectrequest
  content:
  - name: <namespace_name>
    file: <file_source>
```

**_TIP:_** It is important that no cluster-admin level objects are present in the file being sourced. The tasks will fail if run by a non-cluster-admin user.

**_NOTE:_** Since the file sourced by the projectrequest object is going to create the namespace, do not add the `namespace` variable to this object definition.

### policy objects (cluster-admin only)

To create policy level objects like persistent volumes, cluster rolebindings, groups, storage classes, etc. you will need to create a `policy` object which will source a file with the definitions. This would look like this:
```yaml
- object: policy
  content:
  - name: <policy_name>
    file: <file_source>
```

**_NOTE:_** Since these are cluster-wide objects, do not add the `namespace` variable to this object definition.

### other objects

The previously named objects require that the name be written as shown above. Any other objects can be named as you please. In these objects definitions, you source templates that will add any in-project OpenShift objects including buildconfigs, deploymentconfigs, services, routes, etc.

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
```

**_TIP:_** The objects are sourced and applied in the order found in the list. For objects with inter-dependencies, it is important to consider the order these are defined. 

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
