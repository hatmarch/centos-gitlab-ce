#!/bin/bash -x

# This script is a utility script to delete an application in openshift
# running GitLab.
#
# The script will also delete Persistent Volume Claims used to mount
# the data volumes required by GitLab to release them and contained data.
#
# Tyrell Perera (tyrell.perera@gmail.com)

# Delete application
oc delete all -l app=gitlab-ce

# Delete Persistent Volume Claims
oc delete pvc/gitlab-etc
oc delete pvc/gitlab-var-opt
oc delete pvc/gitlab-var-log
