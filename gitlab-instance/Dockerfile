# FROM tyrell/centos-gitlab-ce:12.0.3-ce.0.el7.x86_64
FROM mhildema/tyrell-gitlab-base:v3

# This is a base image with a GitLab CE default install up and running.
MAINTAINER Tyrell Perera <tyrell.perera@gmail.com>

SHELL ["/bin/sh", "-c"],

# Expose web & ssh
EXPOSE 443 80 22

# Define data volumes
# VOLUME ["/etc/gitlab", "/var/opt/gitlab", "/var/log/gitlab"]

COPY fix-sv-temp /assets
RUN /assets/fix-sv-temp

#############################################
# Change user from 'root' to 'git 1007'
# as we do not need root after this point
#############################################
USER 1007

# DEBUG: for testing, see if we can get root to run (permission errors otherwise)
# USER root

# Container ENTRYPOINT
ENTRYPOINT ["assets/container-entrypoint"]

# Run our start script
CMD ["/assets/container-start"]
