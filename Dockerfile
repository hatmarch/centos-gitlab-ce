# Based on the gitlab/gitlab-ce dockerfile here: https://hub.docker.com/r/gitlab/gitlab-ce/dockerfile/
FROM ubuntu:14.04

# This is a base image with a GitLab CE default install up and running.
MAINTAINER Tyrell Perera <tyrell.perera@gmail.com>

# Copy assets
COPY assets/ /assets/

# Install required packages
RUN apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
      ca-certificates \
      openssh-server \
      wget \
      apt-transport-https \
      vim \
      nano

# Download & Install GitLab
# If you run GitLab Enterprise Edition point it to a location where you have downloaded it.
RUN echo "deb https://packages.gitlab.com/gitlab/gitlab-ce/ubuntu/ `lsb_release -cs` main" > /etc/apt/sources.list.d/gitlab_gitlab-ce.list
RUN wget -q -O - https://packages.gitlab.com/gpg.key | apt-key add -
RUN apt-get update && apt-get install -yq --no-install-recommends gitlab-ce

# Manage SSHD through runit
RUN mkdir -p /opt/gitlab/sv/sshd/supervise \
    && mkfifo /opt/gitlab/sv/sshd/supervise/ok \
    && printf "#!/bin/sh\nexec 2>&1\numask 077\nexec /usr/sbin/sshd -D" > /opt/gitlab/sv/sshd/run \
    && chmod a+x /opt/gitlab/sv/sshd/run \
    && ln -s /opt/gitlab/sv/sshd /opt/gitlab/service \
    && mkdir -p /var/run/sshd

# Disabling use DNS in ssh since it tends to slow connecting
RUN echo "UseDNS no" >> /etc/ssh/sshd_config

# Prepare default configuration
RUN ( \
  echo "" && \
  echo "# Docker options" && \
  echo "# Prevent Postgres from trying to allocate 25% of total memory" && \
  echo "postgresql['shared_buffers'] = '1MB'" ) >> /etc/gitlab/gitlab.rb && \
  mkdir -p /assets/ && \
  cp /etc/gitlab/gitlab.rb /assets/gitlab.rb

# Setup GitLab
# RUN /assets/setup

# Allow to access embedded tools
ENV PATH /opt/gitlab/embedded/bin:/opt/gitlab/bin:/assets:$PATH

# Resolve error: TERM environment variable not set.
ENV TERM xterm

# Replace the default sysctl.rb with ours (read comments in file)
#COPY conf/sysctl.rb /opt/gitlab/embedded/cookbooks/package/resources/gitlab_sysctl.rb

# Wrapper to trigger runit and reconfigure GitLab
RUN /assets/initial-wrapper

# DEBUG
RUN echo "SCANNING DIRECTORY" && \
    ls -L /var/opt/gitlab

# Allow users in the root group to access GitLab critical directories
# in the built image (Openshift Dedicated Requirement)
RUN chgrp -R 0 /var/opt/gitlab && \
    chmod -R g=u /var/opt/gitlab && \
    chgrp -R 0 /etc/gitlab && \
    chmod -R g=u /etc/gitlab && \
    chgrp -R 0 /var/log/gitlab && \
    chmod -R g=u /var/log/gitlab

# Add git user to root group and Update permissions to fix directory permission issues
RUN usermod -a -G 0 git && \
    /assets/update-permissions && \
    /assets/fix-permissions /var/opt/gitlab && \
    /assets/fix-permissions /var/log/gitlab && \
    /assets/fix-permissions /etc/gitlab && \
    /assets/fix-permissions /opt/gitlab

RUN echo "SCANNING DIRECTORY" && \
    ls -L /var/opt/gitlab

# Expose web & ssh
EXPOSE 443 80 22

#############################################
# Change user from 'root' to 'git 1007'
# as we do not need root after this point
#############################################
RUN chmod g+w assets
USER root

# Copy the directories to be mounted to a different location
RUN tar -zcvf /assets/gitlab.etc.tar.gz /etc/gitlab && \
    tar -zcvf /assets/gitlab.opt.tar.gz /var/opt/gitlab

# Define data volumes
# NOTE: At this point, whatever is in these directories will get copied to the mount points
# at docker run time
# VOLUME ["/etc/gitlab", "/var/opt/gitlab", "/var/log/gitlab"]
RUN echo "SCANNING DIRECTORY" && \
    ls -L /var/opt/gitlab

# Container ENTRYPOINT
# ENTRYPOINT ["assets/container-entrypoint"]

# Run our start script when the container is run
CMD ["/assets/wrapper"]
