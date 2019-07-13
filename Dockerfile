FROM centos:centos7

# This is a base image with a GitLab CE default install up and running.
MAINTAINER Tyrell Perera <tyrell.perera@gmail.com>

# Copy assets
COPY assets/ /assets/

# Run a Yum update
RUN yum -y update

# Install dependencies
RUN yum install -y curl policycoreutils-python openssh-server && \
    yum install -y postfix && \
    yum clean all

# Install GitLab
RUN curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh >> script.rpm.sh && \
    sh script.rpm.sh && \
    rm script.rpm.sh && \
    yum install -y gitlab-ce && \
    yum clean all

# Setup GitLab
RUN /assets/setup

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

# Initialise GitLab configuration
COPY conf/gitlab.rb /etc/gitlab/gitlab.rb
COPY conf/sysctl.rb /opt/gitlab/embedded/cookbooks/package/resources/sysctl.rb

# Allow users in the root group to access GitLab critical directories
# in the built image (Openshift Dedicated Requirement)
RUN chgrp -R 0 /var/opt/gitlab && \
    chmod -R g=u /var/opt/gitlab && \
    chgrp -R 0 /etc/gitlab && \
    chmod -R g=u /etc/gitlab && \
    chgrp -R 0 /var/log/gitlab && \
    chmod -R g=u /var/log/gitlab

# Update permissions to fix directory permission issues
RUN /assets/update-permissions

# Entrypoint wrapper to handle signal, trigger runit and reconfigure GitLab
RUN /assets/wrapper

HEALTHCHECK --interval=60s --timeout=30s --retries=5 \
CMD /opt/gitlab/bin/gitlab-healthcheck --fail --max-time 10

# Start GitLab services
CMD /opt/gitlab/embedded/bin/runsvdir-start &
