FROM centos:centos7
MAINTAINER Deven Phillips <deven.phillips@redhat.com>

RUN yum install -y patch ansible-2.3.1.0-3.el7

WORKDIR /root
RUN ln -s /usr/lib/python2.7/site-packages /root/lib
RUN curl -L -o /tmp/patch https://github.com/ansible/ansible/commit/240c954c76bd6e0c033d5205d7b94756826e3727.patch && \
    patch --follow-symlinks -Np1 < /tmp/patch && \
    rm -f /tmp/patch && \
    find lib/ansible/ -name "*.py[oc]" | xargs -n 10 rm -f
CMD /bin/sleep infinity