FROM openshift/origin-ansible

USER root

# Update System and install clients
RUN \
    yum install -y --setopt=tsflags=nodocs https://repos.fedorapeople.org/repos/openstack/openstack-queens/rdo-release-queens-1.noarch.rpm; \
    yum -y install python2-pip; \
    pip install --upgrade pip; \
    yum -y install \
      python-ceilometerclient \
      python-cinderclient python-glanceclient \
      python-heatclient python-neutronclient \
      python-novaclient python-saharaclient \
      python-swiftclient python-troveclient \
      python-openstackclient python-dns \
      python2-pyOpenSSL python-shade; \
      python-boto3; \
      yum clean all; \
      rm -rf /var/cache/yum; \
    rpm -e --nodeps python-ipaddress PyYAML; \
    pip install --upgrade \
      "Paste>=2.0.2" \
      "eventlet!=0.18.3,!=0.20.1,<0.21.0,>=0.18.2" \
      openstacksdk

COPY images/casl-ansible/root /

RUN /usr/local/bin/user_setup_casl

USER ${USER_UID}

ENTRYPOINT [ "/usr/local/bin/entrypoint_casl" ]
CMD [ "/usr/local/bin/run" ]
