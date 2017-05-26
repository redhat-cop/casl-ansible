FROM centos:7

MAINTAINER Andrew Block “andrew.block@redhat.com”

# Update System and install clients
RUN yum install -y epel-release; \
  yum update -y; \
  yum install -y python-passlib ansible; \
  yum install -y --setopt=tsflags=nodocs https://repos.fedorapeople.org/repos/openstack/openstack-ocata/rdo-release-ocata-3.noarch.rpm centos-release-openshift-origin; \
  yum install -y python-devel git tar gcc libffi-devel openssl-devel bind-utils httpd-tools java-1.8.0-openjdk-headless\
                 python-pip python-ceilometerclient \
                 python-cinderclient python-glanceclient \
                 python-heatclient python-neutronclient \
                 python-novaclient python-saharaclient \
                 python-swiftclient python-troveclient \
                 python-openstackclient \
                 pyOpenSSL \
                 origin-clients; \
  yum clean all; \
  pip install --upgrade pip jinja2; \
  pip install shade six

ADD bin/start.sh /root/

# Set /root as starting directory
WORKDIR /root

# Helper script
ENTRYPOINT ["/root/start.sh"]
