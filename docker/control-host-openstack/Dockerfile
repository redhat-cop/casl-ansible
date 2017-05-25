FROM centos:7

MAINTAINER Andrew Block “andrew.block@redhat.com”

# Update System and install clients
RUN yum install -y --setopt=tsflags=nodocs https://repos.fedorapeople.org/repos/openstack/openstack-ocata/rdo-release-ocata-3.noarch.rpm centos-release-openshift-origin; \
  yum update -y; \
  yum install -y python-devel epel-release; \
  yum install -y git tar gcc libffi-devel openssl-devel bind-utils httpd-tools java-1.8.0-openjdk-headless\
                 python-pip python-ceilometerclient \
                 python-cinderclient python-glanceclient \
                 python-heatclient python-neutronclient \
                 python-novaclient python-saharaclient \
                 python-swiftclient python-troveclient \
                 python-openstackclient python-passlib \
                 pyOpenSSL \
                 origin-clients; \
  yum clean all; \
  pip install --upgrade pip; \
  pip install --upgrade jinja2; \
  pip install shade six git+git://github.com/ansible/ansible.git@stable-2.3

ADD bin/start.sh /root/

# Set /root as starting directory
WORKDIR /root

# Helper script
ENTRYPOINT ["/root/start.sh"]
