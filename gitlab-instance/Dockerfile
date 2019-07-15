FROM tyrell/centos-gitlab-ce:12.0.3-ce.0.el7.x86_64

# This is a base image with a GitLab CE default install up and running.
LABEL MAINTAINER Tyrell Perera <tyrell.perera@gmail.com>

SHELL ["/bin/sh", "-c"],

# Use our config file to override image default config file
COPY gitlab.rb /etc/gitlab/gitlab.rb

# Expose web & ssh
EXPOSE 443 80 22

# Define data volumes
VOLUME ["/etc/gitlab", "/var/opt/gitlab", "/var/log/gitlab"]

#############################################
# Change user from 'root' to 'git 1007'
# as we do not need root after this point
#############################################
USER 1007

# Container ENTRYPOINT
ENTRYPOINT ["assets/container-entrypoint"]

# Run our start script
CMD ["/assets/container-start"]
