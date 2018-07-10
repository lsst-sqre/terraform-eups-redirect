FROM docker.io/centos:7

USER root

RUN yum clean all -y && \
    yum install -y epel-release && \
    yum update -y && \
    yum clean all -y

COPY modules /tmp/puppet/modules
COPY manifests /tmp/puppet/manifests

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl https://raw.githubusercontent.com/petems/puppet-install-shell/master/install_puppet_agent.sh | sh && \
    /opt/puppetlabs/bin/puppet apply --modulepath=/tmp/puppet/modules --debug /tmp/puppet/manifests/redirector.pp && \
    yum remove -y puppetlabs-release-pc1 puppet-agent && \
    yum clean all -y
SHELL ["/bin/bash", "-c"]

# a shell is needed to use &&, so the json format isn't used
# hadolint ignore=DL3025
CMD /usr/sbin/nginx -t -c /etc/nginx/nginx.conf && \
    /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf
