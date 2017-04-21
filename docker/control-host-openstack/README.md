OpenStack Docker Client
==================

Produces a container capable of acting as a client for OpenStack

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

There are two options for running the `control-node` containers:

1. Raw `docker run` command
2. Background container via `docker-compose`

### Docker Compose (recommended)

Starting the container is done with the following:

```
cd ./docker/control-host-openstack
docker-compose up -d
```

Once the container is running, you can exec into the container to run ansible commands.

```
docker exec -it openstackclientcentos_control-node_1 bash
[]# ansible-playbook -i /root/code/casl-ansible/inventory/sample.casl.example.com.d/inventory/ code/casl-ansible/playbooks/openshift/end-to-end.yml
```

### Raw Docker

```
docker run -it --name control-host -v $HOME/.ssh:/root/.ssh -v $HOME/.config/openstack:/root/.config/openstack -v $HOME/src:/root/code -v $HOME/.ansible.cfg:/root/.ansible.cfg docker.io/redhatcop/control-host-openstack bash
[]# ansible-playbook -i /root/code/casl-ansible/inventory/sample.casl.example.com.d/inventory/ code/casl-ansible/playbooks/openshift/end-to-end.yml
```

### OpenStack Configuration Files

The above commands expect you to have an link:https://docs.openstack.org/user-guide/common/cli-set-environment-variables-using-openstack-rc.html[OpenStack RC file] at `~/.config/openstack/openrc.sh`.

### Repository Content & Scripts

The above commands expect your ansible inventories and playbooks repos to live at `~/src`. If it lives elsewhere you'll need to update those file paths, either in the command, or in `docker-compose.yml`.

### SSH Keys

The above commands expect to mount the ssh keys needed to authenticate to openstack servers from ~/.ssh. If they live elsewhere, you'll need to update those paths in the command or in `docker-compose.yml`.

## Troubleshooting

Below are some of helpful hints for resolving issues experiencing while configuring and running the container

**Issue #1**

```
$ ./run.sh
time="2015-09-01T11:22:05-04:00" level=fatal msg="Get http:///var/run/docker.sock/v1.18/images/json: dial unix /var/run/docker.sock: no such file or directory. Are you trying to connect to a TLS-enabled daemon without TLS?"
Building Docker Image rhtconsulting/rhc-openstack-client....
Sending build context to Docker daemon
FATA[0000] Post http:///var/run/docker.sock/v1.18/build?cgroupparent=&cpusetcpus=&cpushares=0&dockerfile=Dockerfile&memory=0&memswap=0&rm=1&t=rhtconsulting%2Frhc-openstack-client: dial unix /var/run/docker.sock: no such file or directory. Are you trying to connect to a TLS-enabled daemon without TLS?
```

**Resolution #1**

Verify the Docker service is running

**Issue #2**

```
./run.sh
time="2015-09-01T11:32:36-04:00" level=fatal msg="Get http:///var/run/docker.sock/v1.18/images/json: dial unix /var/run/docker.sock: permission denied. Are you trying to connect to a TLS-enabled daemon without TLS?"
Building Docker Image rhtconsulting/rhc-openstack-client....
Sending build context to Docker daemon
FATA[0000] Post http:///var/run/docker.sock/v1.18/build?cgroupparent=&cpusetcpus=&cpushares=0&dockerfile=Dockerfile&memory=0&memswap=0&rm=1&t=rhtconsulting%2Frhc-openstack-client: dial unix /var/run/docker.sock: permission denied. Are you trying to connect to a TLS-enabled daemon without TLS?
Starting OpenStack Client Container....
FATA[0000] Post http:///var/run/docker.sock/v1.18/containers/create: dial unix /var/run/docker.sock: permission denied. Are you trying to connect to a TLS-enabled daemon without TLS?
```

**Resolution #2**

This error indicates the currently logged in user is unable to access the docker socket.

To resolve this issue, create a new *docker* group and add the user to the *docker* group

```
groupadd docker
usermod -a -G docker ${USER}
systemctl enable docker
systemctl restart docker
```

Reboot the machine or log out/log in to reload your environment and complete the configurations.
