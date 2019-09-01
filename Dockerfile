FROM centos:centos7

# This is a base image with a GitLab CE default install up and running.
MAINTAINER Tyrell Perera <tyrell.perera@gmail.com>

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

# Copy assets
COPY assets/ /assets/

# Setup GitLab
RUN /assets/setup

# Allow to access embedded tools
ENV PATH /opt/gitlab/embedded/bin:/opt/gitlab/bin:/assets:$PATH

# Resolve error: TERM environment variable not set.
ENV TERM xterm

# Expose web & ssh
EXPOSE 443 80 22

# Replace the default sysctl.rb with ours (read comments in file)
COPY conf/gitlab_sysctl.rb /opt/gitlab/embedded/cookbooks/package/resources/gitlab_sysctl.rb

# Use our config file to override image default config file (must be done before reconfigure)
COPY conf/gitlab.rb /assets/gitlab.rb

# Wrapper to trigger runit and reconfigure GitLab (probably needs to be run as root)
RUN /assets/gitlab-configure

# Allow users in the root group to access GitLab critical directories
# in the built image (Openshift Dedicated Requirement)
RUN chgrp -R 0 /var/opt/gitlab && \
    chmod -R g=u /var/opt/gitlab && \
    chgrp -R 0 /etc/gitlab && \
    chmod -R g=u /etc/gitlab && \
    chgrp -R 0 /var/log/gitlab && \
    chmod -R g=u /var/log/gitlab

# Add git user to root group and Update permissions to fix directory permission issues
RUN /assets/fix-groups && \
    /assets/update-permissions && \
    /assets/fix-permissions /var/opt/gitlab && \
    /assets/fix-permissions /var/log/gitlab && \
    /assets/fix-permissions /etc/gitlab && \
    /assets/fix-permissions /opt/gitlab && \
    /assets/fix-sv

#############################################
# Change user from 'root' to 'git 1007'
# as we do not need root after this point
#############################################
USER 1007

# Container ENTRYPOINT
ENTRYPOINT ["assets/container-entrypoint"]

# Run our start script
CMD ["/assets/container-start"]
