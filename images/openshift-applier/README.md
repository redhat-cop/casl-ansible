OpenShift Applier Docker Client
===============================

Produces a container capable of acting as a control host for `openshift-applier`

**_NOTE:_** This is also used to enable the use of versions that may not be quite main stream (or a pre-release).


## Setup

The following steps are required to run the docker client.

1. Install docker and docker-compose
  1. on RHEL/Fedora: ```{yum/dnf} install docker docker-compose```
  2. on Windows: [Install Docker for Windows](https://docs.docker.com/windows/step_one/)
  3. on OSX: [Max OS X](https://docs.docker.com/installation/mac/)
  4. on all other Operating Systems: [Supported Platforms](https://docs.docker.com/installation/)
2. Give your user access to run Docker containers (this is only required in Linux/Unix distros)
```
groupadd docker
usermod -a -G docker ${USER}
systemctl enable docker
systemctl restart docker
```

## Running

A typical run of the image would look like:

```
docker run  \ 
      -v $HOME/.kube:/root/.kube \
      -v $HOME/src/:/tmp/src \
      -t redhatcop/openshift-applier \
      ansible-playbook -i /tmp/src/<inventory> /tmp/src/casl-ansible/playbooks/openshift-cluster-seed.yml
```

NOTE: The above commands expects the following inputs:
* You already have a valid session with the OpenShift cluster (i.e.: using `oc login`) with the session data stored in the default directory of `$HOME/.kube`
* Your ansible inventories and playbooks repos to exist in `$HOME/src`
* Your ansible inventories and playbooks repos to live within the same directory, mounted at `/tmp/src`

**_TIP:_** If your inventories, playbooks, etc. do not exist at the above mentioned paths, make sure to adjust the arguments to the `-v` parameters accordingly

## Building the Image

This image is built and published to docker.io, so there's no reason to build it if you're just wanting to use the latest stable version. However, if you need to build it for development reasons, here's how:

```
cd ./casl-ansible
docker build -t redhatcop/openshift-applier images/openshift-applier
```

## Troubleshooting

TBD
