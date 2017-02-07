FROM centos:7

MAINTAINER Andrew Block “andrew.block@redhat.com”

ADD bin/start.sh /root/

# Update System and install clients
RUN yum install -y --setopt=tsflags=nodocs https://repos.fedorapeople.org/repos/openstack/openstack-mitaka/rdo-release-mitaka-6.noarch.rpm centos-release-openshift-origin; \
  yum update -y; \
  yum install -y python-devel epel-release; \
  yum install -y git tar gcc libffi-devel openssl-devel bind-utils ansible \
                 python-pip python-ceilometerclient \
                 python-cinderclient python-glanceclient \
                 python-heatclient python-neutronclient \
                 python-novaclient python-saharaclient \
                 python-swiftclient python-troveclient \
                 python-openstackclient python-passlib \
                 pyOpenSSL \
                 origin-clients; \
  yum clean all; \
  pip install shade

# Set /root as starting directory
WORKDIR /root

# Default Command
CMD ["/bin/bash"]

# Helper script
ENTRYPOINT ["/root/start.sh"]
