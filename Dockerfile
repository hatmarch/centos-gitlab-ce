FROM centos:centos7

# This is a base image with a GitLab CE default install up and running.
MAINTAINER Tyrell Perera <tyrell.perera@gmail.com>

# Install and Configure Required Dependencies
RUN yum install -y curl policycoreutils-python openssh-server

# Install Postfix service to send notification emails, and enable it to start at system boot, then check if its up and running
RUN yum install -y postfix

# Add the GitLab package YUM repository to the container
RUN curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh >> script.rpm.sh
RUN sh script.rpm.sh

# Install the GitLab Community Edition package
RUN yum install -y -v --rpmverbosity=debug gitlab-ce

# Open port 80 (HTTP) and 443 (HTTPS) to allow connections in the system firewall
EXPOSE 80/tcp
EXPOSE 443/tcp
