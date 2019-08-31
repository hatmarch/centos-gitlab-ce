FROM centos:centos7

# Based on the gitlab/gitlab-ce dockerfile here: https://hub.docker.com/r/gitlab/gitlab-ce/dockerfile/
# FROM ubuntu:14.04

# This is a base image with a GitLab CE default install up and running.
MAINTAINER Tyrell Perera <tyrell.perera@gmail.com>

# Run a Yum update.  NOTE: This should be done on the same line as the other install commands otherwise this
# update layer could get cached separate from the other packages
# see also: https://blog.developer.atlassian.com/common-dockerfile-mistakes/
RUN yum -y update && \
    yum install -y curl policycoreutils-python openssh-server && \
    yum install -y postfix && \
    yum install net-tools -y && \
    yum clean all

# Install GitLab-CE (omnibus)
# curl -s https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash
RUN curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh >> script.rpm.sh && \
    sh script.rpm.sh && \
    rm script.rpm.sh && \
    yum install -y gitlab-ce && \
    yum clean all

# Copy assets
COPY assets/ /assets/

# Setup GitLab
RUN /assets/setup

# Allow to access embedded tools
ENV PATH /opt/gitlab/embedded/bin:/opt/gitlab/bin:/assets:$PATH

# Resolve error: TERM environment variable not set.
ENV TERM xterm

# Replace the default sysctl.rb with ours (read comments in file)
COPY conf/sysctl.rb /opt/gitlab/embedded/cookbooks/package/resources/gitlab_sysctl.rb

# Wrapper to trigger runit and reconfigure GitLab
RUN /assets/initial-wrapper

# DEBUG
RUN echo "SCANNING DIRECTORY" && \
    ls -L /var/opt/gitlab

# Allow users in the root group to access GitLab critical directories
# in the built image (Openshift Dedicated Requirement)
# RUN chgrp -R 0 /var/opt/gitlab && \
#     chmod -R g=u /var/opt/gitlab && \
#     chgrp -R 0 /etc/gitlab && \
#     chmod -R g=u /etc/gitlab && \
#     chgrp -R 0 /var/log/gitlab && \
#     chmod -R g=u /var/log/gitlab

# # Add git user to root group and Update permissions to fix directory permission issues
# RUN usermod -a -G 0 git && \
#     /assets/update-permissions && \
#     /assets/fix-permissions /var/opt/gitlab && \
#     /assets/fix-permissions /var/log/gitlab && \
#     /assets/fix-permissions /etc/gitlab && \
#     /assets/fix-permissions /opt/gitlab

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
# (-h flag preserves the symlinks)
# (-p flag preserves permissions)
RUN tar -zhpcvf /assets/gitlab.etc.tar.gz /etc/gitlab && \
    tar -zhpcvf /assets/gitlab.opt.tar.gz /var/opt/gitlab

# Define data volumes
# NOTE: At this point, whatever is in these directories will get copied to the mount points
# at docker run time
#VOLUME ["/etc/gitlab", "/var/opt/gitlab", "/var/log/gitlab"]
RUN echo "SCANNING DIRECTORY" && \
    ls -L /var/opt/gitlab

# Container ENTRYPOINT
# ENTRYPOINT ["assets/container-entrypoint"]

# Run our start script when the container is run
CMD ["/assets/wrapper"]
