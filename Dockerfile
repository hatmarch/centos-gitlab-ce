FROM centos:centos7

# This is a base image with a GitLab CE default install up and running.
LABEL MAINTAINER Tyrell Perera <tyrell.perera@gmail.com>

SHELL ["/bin/sh", "-c"],

# Copy assets
COPY assets/ /assets/

# Install dependencies
RUN yum -y update && \
    yum install -y curl policycoreutils-python openssh-server && \
    yum install -y postfix && \
    yum clean all

# Install GitLab
RUN curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh >> script.rpm.sh && \
    sh script.rpm.sh && \
    rm script.rpm.sh && \
    yum install -y -v --rpmverbosity=debug gitlab-ce && \
    yum clean all

# Setup GitLab
RUN /assets/setup

# Allow users in the root group to access GitLab directory in the built image (Openshift Dedicated Requirement)
RUN chgrp -R 0 /var/opt/gitlab && \
    chmod -R g=u /var/opt/gitlab && \
    chgrp -R 0 /etc/gitlab && \
    chmod -R g=u /etc/gitlab && \
    chgrp -R 0 /var/log/gitlab && \
    chmod -R g=u /var/log/gitlab

#############################################
# Change user from 'root' to 'git 998'
# as we do not need root after this point
#############################################
USER 998

# Allow to access embedded tools
ENV PATH /opt/gitlab/embedded/bin:/opt/gitlab/bin:/assets:$PATH

# Resolve error: TERM environment variable not set.
ENV TERM xterm

# Expose web & ssh
EXPOSE 443 80 22

# Resolve error: TERM environment variable not set.
ENV TERM xterm

# Define data volumes
VOLUME ["/etc/gitlab", "/var/opt/gitlab", "/var/log/gitlab"]

# Wrapper to handle signal, trigger runit and reconfigure GitLab
CMD ["/assets/wrapper"]

HEALTHCHECK --interval=60s --timeout=30s --retries=5 \
CMD /opt/gitlab/bin/gitlab-healthcheck --fail --max-time 10
