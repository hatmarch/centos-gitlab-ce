FROM gitlab/gitlab-ce

# dockerfile for volumes that have already been setup

# This is a base image with a GitLab CE default install up and running.
MAINTAINER Tyrell Perera <tyrell.perera@gmail.com>

USER root

# Run the existing wrapper to configure everything for the first time
COPY assets/initial-wrapper /assets/wrapper
RUN chmod +x /assets/wrapper
RUN /assets/wrapper

# Copy the directories to be mounted to a different location
RUN tar -zcvf /assets/gitlab.etc.tar.gz /etc/gitlab && \
    tar -zcvf /assets/gitlab.opt.tar.gz /var/opt/gitlab

# Remove the contents from directories that are to be mounted
#RUN rm -rf /etc/gitlab/* && \
#    rm -rf /var/log/gitlab/* && \
#    rm -rf /var/opt/gitlab/*

# Wrapper to trigger gitlab-ctl restart
COPY assets/wrapper /assets/wrapper
RUN chmod +x /assets/wrapper
