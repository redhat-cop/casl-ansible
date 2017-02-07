FROM registry.access.redhat.com/rhel7/rhel

MAINTAINER Andrew Block “andrew.block@redhat.com”

ADD bin/start.sh /root/

# Update System and install clients
RUN yum update -y; \
    yum install -y \
	python-devel \
	https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
	https://repos.fedorapeople.org/repos/openstack/openstack-liberty/rdo-release-liberty-5.noarch.rpm && \
    sed -i -e "s/^enabled=1/enabled=0/" /etc/yum.repos.d/epel.repo && \
    yum install -y \
	git \
	tar \
	bind-utils \
	ftp://ftp.muug.mb.ca/mirror/centos/7.2.1511/os/x86_64/Packages/python-webob-1.2.3-6.el7.noarch.rpm && \
    yum install -y --enablerepo=epel \
	python-ceilometerclient \
	python-cinderclient \
	python-glanceclient \
	python-heatclient \
	python-neutronclient \
	python-novaclient \
	python-saharaclient \
	python-swiftclient \
	python-troveclient \
	python-openstackclient && \
    yum install -y --enablerepo=rhel-7-server-ose-3.1-rpms \
	atomic-openshift-utils && \
    yum clean all

# Set /root as starting directory
WORKDIR /root
	
# Default Command
CMD ["/bin/bash"]

# Helper script
ENTRYPOINT ["/root/start.sh"]
