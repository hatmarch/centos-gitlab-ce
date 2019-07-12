FROM tyrell/centos-gitlab-ce:12.0.3-ce.0.el7.x86_64

# This is a base image with a GitLab CE default install up and running.
LABEL MAINTAINER Tyrell Perera <tyrell.perera@gmail.com>

# Use our config file to override image default config file
COPY gitlab.rb /etc/gitlab/gitlab.rb


#############################################
# Change user from 'root' to 'git 998'
# as we do not need root after this point
#############################################
USER 998

# Run reconfigure using our gitlab.rb file from above
RUN gitlab-ctl reconfigure
