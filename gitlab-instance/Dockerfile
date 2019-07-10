FROM tyrell/centos-gitlab-ce:12.0.3-ce.0.el7.x86_64

# This is a base image with a GitLab CE default install up and running.
LABEL MAINTAINER Tyrell Perera <tyrell.perera@gmail.com>

# Open ports necessary to allow connections in the system firewall
EXPOSE 80/tcp
EXPOSE 443/tcp

# Allow users in the root group to access them in the built image (Openshift Dedicated Requirement)
RUN chgrp -R 0 /opt/gitlab && \
    chmod -R g=u /opt/gitlab

# Use our config file to override image default config file
COPY gitlab.rb /etc/gitlab/gitlab.rb

# Manually run runsvdir-start as a background process before running reconfigure and run reconfigure
RUN /opt/gitlab/embedded/bin/runsvdir-start &
RUN gitlab-ctl reconfigure
