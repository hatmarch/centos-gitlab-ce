#!/bin/bash -x

# This script is a utility script to create an application in openshift to
# run GitLab.
#
# The script will also create Persistent Volume Claims to mount
# the data volumes required by GitLab to store persistent data.
#
# Tyrell Perera (tyrell.perera@gmail.com)

oc new-app tyrell/centos-gitlab-ce-instance:latest \
    --name=gitlab-ce-instance

# Create volume /etc/gitlab
oc set volume dc/gitlab-ce-instance --add \
    --type=persistentVolumeClaim \
    --claim-size=1Gi \
    --mount-path=/etc/gitlab \
    --claim-name=gitlab-etc \
    --name=gitlab-etc \
    --overwrite

# Create volume /var/opt/gitlab
oc set volume dc/gitlab-ce-instance --add \
    --type=persistentVolumeClaim \
    --claim-size=1Gi \
    --mount-path=/var/opt/gitlab \
    --claim-name=gitlab-var-opt \
    --name=gitlab-var-opt \
    --overwrite

# Create volume /var/log/gitlab
oc set volume dc/gitlab-ce-instance --add \
    --type=persistentVolumeClaim \
    --claim-size=1Gi \
    --mount-path=/var/log/gitlab \
    --claim-name=gitlab-var-log \
    --name=gitlab-var-log \
    --overwrite
