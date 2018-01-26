AWS Docker Client
==================

Produces a container capable of acting as a client for AWS

## Setup

The following steps are required to run the docker client.

1. Install docker
  1. on RHEL/Fedora: ```{yum/dnf} install docker```
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
docker run -u `id -u` \
      -v $HOME/.ssh:/opt/app-root/src/.ssh \
      -v $HOME/aws-credentials.csv:/opt/app-root/src/aws-credentials.csv \
      -v $HOME/src/:/tmp/src \
      -e INVENTORY_DIR=/tmp/src/casl-ansible/inventory/sample.aws.example.com.d/inventory/ \
      -e PLAYBOOK_FILE=/tmp/src/casl-ansible/playbooks/openshift/end-to-end.yml \
      -e OPTS="-e aws_key_name=my-public-key" -t \
      redhatcop/installer-aws
```

The above commands expects the following inputs:
* Your ssh key (~/.ssh/id_rsa) to be mounted in the container at `/opt/app-root/src/.ssh/id_rsa`
* Your AWS credentials (in CSV format) is available in your home directory
* Your ansible inventories and playbooks repos to live within the same directory, mounted at `/tmp/src`

> **Note:** The AWS credentials file can be using the .csv as downloaded from AWS, or a .sh file can be used and will be sourced as-is (make sure the **AWS_SECRET_ACCESS_KEY** and **AWS_ACCESS_KEY_ID** environment variables are exported correctly).

## Building the Image

This image is built and published to docker.io, so there's no reason to build it if you're just wanting to use the latest stable version. However, if you need to build it for development reasons, here's how:

```
cd ./casl-ansible
docker build -f images/installer-aws/Dockerfile -t redhatcop/installer-aws .
```

## Troubleshooting

Below are some of helpful hints for resolving issues experiencing while configuring and running the container

TBD

