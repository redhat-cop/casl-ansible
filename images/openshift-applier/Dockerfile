FROM centos:centos7

ENV OC_CLIENT_MIRROR https://mirror.openshift.com/pub/openshift-v3/clients/3.7.26/linux/oc.tar.gz

USER root

# Update System and install clients
RUN  yum install -y epel-release; \
  yum install -y python-pip git; \
  pip install --upgrade pip;  \
  pip install git+https://github.com/ansible/ansible.git@devel

RUN curl $OC_CLIENT_MIRROR | tar -C /usr/local/bin/ -xzf -

CMD /bin/sleep infinity

