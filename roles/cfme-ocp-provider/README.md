cfme-ocp-provider
=========

Role used to configure OpenShift as a Container Provider to Red Hat CloudForms.


Requirements
------------

None

Role Variables
--------------

The following role variables must be provided

```
cfme_host: <hostname of the CloudForms instance>
cfme_username: <Username to access CloudForms>
cfme_password: <Password to access CloudForms>
```

The following variables can also be provided in order to customize the configuration

```
ocp_master_host: <OpenShift API Host>
ocp_master_port: <OpenShift API Port>
hawkular_host: <Hawkular Hostname>
hawkular_port: <Hawkular Port>
ocp_token: <OAuth token to access OpenShift Rest API>
hawkular_token: <OAuth token to access Hawkular Metrics>
ocp_container_provier_name: <Name of the Container Provider in CloudForms to create for OpenShift>
default_token_sa_namespace: <Namespace of the Service Account containing the OAuth token if one is not provided for OpenShift or Hawkular>
default_token_sa_name: <Name of the Service Account containing the OAuth token if one is not provided for OpenShift or Hawkular>
```

Dependencies
------------
None


Example Playbook
----------------

The following is a sample playbook

```
# Example
- hosts: masters[0]
  roles:
    - role: cfme-ocp-provider
      cfme_host: cloudforms.example.com
```

License
-------

BSD

Author Information
------------------
Red Hat Community of Practice & staff of the Red Hat Open Innovation Labs.
