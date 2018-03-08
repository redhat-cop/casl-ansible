FROM openshift/origin-ansible

MAINTAINER Andrew Block “andrew.block@redhat.com”

USER root

# Update System and install clients
RUN yum install -y epel-release; \
  yum install -y --setopt=tsflags=nodocs https://repos.fedorapeople.org/repos/openstack/openstack-pike/rdo-release-pike-1.noarch.rpm ;\
  yum install -y python-pip python-ceilometerclient \
                 python-cinderclient python-glanceclient \
                 python-heatclient python-neutronclient \
                 python-novaclient python-saharaclient \
                 python-swiftclient python-troveclient \
                 python-openstackclient python-dns \
                 pyOpenSSL;\
  yum clean all; \
  pip install --upgrade pip jinja2; \
  pip install shade six

COPY images/installer-openstack/root /

RUN /usr/local/bin/user_setup_casl

USER ${USER_UID}

ENTRYPOINT [ "/usr/local/bin/entrypoint_casl" ]
CMD [ "/usr/local/bin/run" ]
