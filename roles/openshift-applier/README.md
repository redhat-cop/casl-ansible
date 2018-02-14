# openshift-applier

Role used to apply OpenShift objects to an existing OpenShift Cluster.

<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [openshift-applier](#openshift-applier)
	- [Requirements](#requirements)
	- [Role Usage](#role-usage)
		- [Sourcing OpenShift Object Definitions](#sourcing-openshift-object-definitions)
		- [Sourcing a directory with files](#sourcing-a-directory-with-files)
		- [Ordering of Objects in the inventory](#ordering-of-objects-in-the-inventory)
		- [Privileged Objects](#privileged-objects)
		- [Object Entries in the Inventory](#object-entries-in-the-inventory)
		- [Override default actions with `file_action` and `template_action`](#override-default-actions-with-fileaction-and-templateaction)
		- [Filtering content based on tags](#filtering-content-based-on-tags)
		- [Deprovisioning](#deprovisioning)
		- [Dependencies](#dependencies)
	- [Example Playbook](#example-playbook)
	- [License](#license)
	- [Author Information](#author-information)

<!-- /TOC -->


## Requirements

A working OpenShift cluster that can be used to populate things like namespaces, policies and PVs (all require cluster-admin), or application level content (cluster-admin not required).


## Role Usage

### Sourcing OpenShift Object Definitions

The variable definitions come in the form of an object, `openshift_cluster_content`, which contains sub-objects containing file, template, and parameter definitions. At its simplest, this definition looks like this:

```yaml
openshift_cluster_content:
- galaxy_requirements: # Optional: only needed if pre/post steps are specified below
    - "path/to/galaxy/requirements.yml" # Has to be a local file - e.g: with the inventory
- object: <object_type>
  pre_steps: # Optional: pre-steps at object level can be added if desired
    - role: <path to an ansible role>
  content:
  - name: <definition_name>
    pre_steps: # Optional: pre-steps at content level can be added if desired
      - role: <path to an ansible role>
        vars: # Optional: only needed if the role above needs values passed
          <key1>: <value1>  
    file: <file source>
    file_action: <apply|create> # Optional: Defaults to 'apply'
    tags: # Optional: Tags are only needed if `filter_tags` is used
    - tag1
    - tag2
    post_steps: # Optional: post-steps at content level can be added if desired
      - role: <path to an ansible role>
  post_steps: # Optional: post-steps at object level can be added if desired
    - role: <path to an ansible role>
- object: <object_type>
  content:
  - name: <definition_name>
    template: <template_source>
    template_action: <apply|create> # Optional: Defaults to 'apply'
    params: <params_file_source>
    namespace: <target_openshift_namespace>
```

You have the choice of sourcing a `file` or a `template`. The `file` definition expects that the sourced file has all definitions set and will NOT accept any parameters (i.e.: static content). The `template` definition expects a `params` file to be sourced along with it which will be passed into the template.

**_TIP:_** Both choices give you the option of defining target namespaces in the template manually, or adding the `namespace` variable alongside the template and params (where applicable)

The `tags` definition is a list of tags that will be processed if the `filter_tags` variable/fact is supplied. See [Filtering content based on tags](https://github.com/redhat-cop/casl-ansible/tree/filter/roles/openshift-applier#filtering-content-based-on-tags) below for more details.

The pre/post definitions are a set of pre and post roles to execute before/after a particular portion of the inventory is applied. This can be before/afterthe object levels - i.e.: before and after all of the content, or before/after certain files/templates at a content level.

### Sourcing a directory with files

You can source a directory composed of static files (without parameters) using `files` instead of defining each file individually.

NOTE: Formerly, this was done using a separate `content_dir` structure. This has been deprecated.

That would look like this:
```yaml
- object: policy
  content:
  - name: directory of files
    file: <path-to>/directory/
```
In this example above, all of the files in the `<path-to>/directory/` directory would get sourced and applied to the cluster (native OpenShift processing).

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


### Override default actions with `file_action` and `template_action`

The file and template entries have default handling of `apply` - i.e.: how the `oc` command applies the object(s). This can be overridden with with the inventory variables `file_action` and `template_action`. Normally this should not be necessary, but in some cases it may be necessary for various reasons such as permission levels. One example is if a `ProjectRequest` is defined as templates. In that case, if a non-privileged user tries to apply the objects it will error out as the user's permissions do not allow for `oc apply` at the cluster scope. In that case, it will be required to override the action with `template_action: create`. For example:

```yaml
openshift_cluster_content:
- object: projectrequest
  content:
  - name: "my-space1"
    file: "my-space.yml"
  - name: "my-space2"
    template: "my-space-template.yml"
    params: "my-space-paramsfile"
    template_action: create       # Note the template_action set to override the default 'apply' action
```

Valid `file_action` and `template_action` values are `apply`, `create`, and `delete`.

### Filtering content based on tags

The `openshift-applier` supports the use of tags in the inventory (see example above) to allow for filtering which content should be processed and not. The `filter_tags` variable/fact takes a comma separated list of tags that will be processed and only content/content_dir with matching tags will be applied.

**_NOTE:_** Entries in the inventory without tags will not be processed when a valid list is supplied with the `filter_tags` option.

```
filter_tags=tag1,tag2

```

### Pre/Post steps

The `openshift-applier` supports the use of pre and post steps to allow for tasks to be executed before / after content is loaded up in OpenShift. This can be useful for things like:
 - waiting on a deployment to become ready before proceeding to the next
 - seeding the application with content after deployment
 - applying additional tweaks to the OpenShift objects post deployment (e.g.: labels, env variables, etc.)

The pre/post steps can be added at both the `object` level as well as the `content level`. See example at the top for more details.

In essence, the pre/post steps are ansible roles that gets executed in the order they are found in the inventory. These roles are sourced from the `galaxy_requirements` file part of the inventory. See the official [Ansible Galaxy docs for more details on the requirements yaml file](http://docs.ansible.com/ansible/latest/galaxy.html#installing-multiple-roles-from-a-file).

**_NOTE:_** it is important that the repos used for pre/post roles have the `meta/main.yml` file setup correctly. See the [Ansible Galaxy docs](docs.ansible.com/ansible/latest/galaxy.html) for more details.

For roles that requires input parameters, the implementation also supports supplying variables, as part of the inventory, to the pre/post steps. See example at the top for more details.

### Deprovisioning

The `openshift-applier` role also supports global deprovisioning of resources. This can be done either using `provision: false`. Setting `-e provision: false` on a run essentially acts like a big 'undo' button, re-running all files and templates through `oc delete -f <resources>`. This can be useful when you want to do a full cleanup to ensure the integrity of you IaC repo, or for simple cleanup while testing changes.

### Dependencies

- openshift-login: Ansible role used to login a user to the OpenShift cluster.


## Example Playbook

TBD

## License

BSD

## Author Information

Red Hat Community of Practice & staff of the Red Hat Open Innovation Labs.
