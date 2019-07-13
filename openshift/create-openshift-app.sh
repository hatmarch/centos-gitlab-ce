#!/bin/bash -x

# This script is a utility script to create an application in openshift to
# run GitLab.
#
# The script will also create Persistent Volume Claims to mount
# the data volumes required by GitLab to store persistent data.
#
# Tyrell Perera (tyrell.perera@gmail.com)

oc new-app tyrell/centos-gitlab-ce:12.0.3-ce.0.el7.x86_64 \
    --name=gitlab-ce

# Create volume /etc/gitlab
oc volume dc/gitlab-ce --add \
    --type=persistentVolumeClaim \
    --claim-size=1Gi \
    --mount-path=/etc/gitlab \
    --name=gitlab-etc \
    --claim-name=gitlab-etc \
    --overwrite

# Create volume /var/opt/gitlab
oc volume dc/gitlab-ce --add \
    --type=persistentVolumeClaim \
    --claim-size=1Gi \
    --mount-path=/var/opt/gitlab \
    --name=gitlab-var-opt \
    --claim-name=gitlab-var-opt \
    --overwrite

# Create volume /var/log/gitlab
oc volume dc/gitlab-ce --add \
    --type=persistentVolumeClaim \
    --claim-size=1Gi \
    --mount-path=/var/log/gitlab \
    --name=gitlab-var-log \
    --claim-name=gitlab-var-log \
    --overwrite
