FROM openshift/origin-ansible

USER root

RUN yum install -y python2-boto python2-pip && \
    pip install boto3

RUN sed -i 's/inventory_ignore_extensions =\(.*\)/inventory_ignore_extensions =\1, .ini/g' /usr/share/ansible/openshift-ansible/ansible.cfg

COPY images/installer-aws/root /

USER ${USER_UID}

ENTRYPOINT [ "/usr/local/bin/entrypoint_casl" ]
CMD [ "/usr/local/bin/run" ]
