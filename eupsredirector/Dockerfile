FROM docker.io/centos:7
MAINTAINER sqre-admin

USER root

RUN yum clean all -y && \
    yum install -y epel-release && \
    yum update -y && \
    yum clean all -y

COPY modules /tmp/puppet/modules
COPY manifests /tmp/puppet/manifests

RUN curl https://raw.githubusercontent.com/petems/puppet-install-shell/master/install_puppet_agent.sh | sh && \
    /opt/puppetlabs/bin/puppet apply --modulepath=/tmp/puppet/modules --debug /tmp/puppet/manifests/redirector.pp

ENTRYPOINT /usr/sbin/nginx -t -c /etc/nginx/nginx.conf && \
    /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf
