OpenShift Host Builder
==================

Produces a container capable of acting as a host for building OpenShift environments

*Note: A registered and subscribed instance of Red Hat Enterprise Linux (RHEL) 7 instance with entitlements to OpenShift Enterprise 3 is required*

## Setup

The following steps are required to run the builder.

1. Install docker
  1. on RHEL: ```yum install docker```
2. Give your user access to run Docker containers
```
groupadd docker
usermod -a -G docker ${USER}
systemctl enable docker
systemctl restart docker
```


## Running

The process of creating and running the docker container is facilitated through the ```run.sh``` script inside this repository.  

It will produce the docker image based on a *Dockerfile* and run the docker container based on the following parameters:

```
$ ./docker/openshift-host-builder/run.sh --help

     Usage: ./docker/openstack-docker-client/run.sh [options]
     Options:
     --configdir=<configdir>       : Directory containing Openstack configuration files (Default: ~/.openstack/)
     --image-name=<image-name>                 : Name of the assembled image (Default: openshift-host-builder)
     --keep                        : Whether to keep the the container after exiting
     --ssh=<ssh>                   : Location of SSH keys to mount into the container (Default: ~/.ssh)
     --repository=<repository>     : Directory containing a repository to mount inside the container
     --help                        : Show Usage Output
```

The script can be run as is with  ```run.sh``` which will create a new image if one was not created previously and then start the container.

## Customizing the parameters

Executing the ```run.sh``` script with no arguments will provide a bare container with the openstack client tools installed. This is great if all you want to do is run manual `nova` commands, but in order to make this more useful, you'll need to pass some parameters to share resources from your local environment. The following parameters can be configured to customize the behavior of the container environment.

### OpenStack Configuration Files

As part of the [OpenStack client configuration](provisioning/openstack/README.md), a client configuration file was downloaded from OpenStack and placed in the ```~/openstack``` directory. When the docker container is started, this directory is mounted inside the container and all ```*.sh``` files are sourced to allow the client to obtain the API endpoint and authentication details.

You can choose to provide an alternate location by using the ```--configdir``` parameter of the ```run.sh``` script

### Repository Content & Scripts

If you are using a repository or some other source folder containing scripts that you would like to have mounted in the container, the ```--repository``` option can be passed which will mount a folder in the container at ```/root/repository```.

### SSH Keys

Since the interaction with OpenStack typically requires the use of SSH communication, the private key from the logged in users running the Docker container will be copied to the containers' ```~/.ssh``` folder. You can choose to modify the default source location by providing the ```--ssh``` option with a reference to the directory  

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
