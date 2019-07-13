## A GitLab CE base image to run a GitLab CE instance

This project contains a Docker image that can be used as a base image to create a new Docker image customised for your environment.


### Building the Docker image yourself and hosting it

  1. Clone this repository.
  2. Build the Docker image.

     `docker build -t <your-docker-repo>/centos-gitlab-ce:latest .`

  3. Deploy the image to your repository

      `docker push <your-docker-repo>/centos-gitlab-ce:latest`


### Running this image in Openshift

  1. `oc login`
  2. `oc new-project gitlab`
  3. `sh openshift/create-openshift-app.sh`

The openshift/create-openshift-app.sh script uses the image hosted at https://hub.docker.com/r/tyrell/centos-gitlab-ce and creates the required Persistent Volume Claims in Openshift for persistent storage volume mounts.

Delete the Openshift application using;

      'oc delete all -l app=gitlab-ce'


### Initialising GitLab

Run '/assets/wrapper' to initialise GitLab for the first time. This script creates all the necessary dependencies and database schemas etc.


### Notes

  1. conf/gitlab.rb is copied into the image during build.
  2. conf/sysctl.rb is a modified version to prevent all the sysctl kernel parameter modifications performed during ed during reconfigure. It is expected that PostgreSQL will be running on its own container during a proper deployment.


### License
Copyright (c) 2017 Tyrell Perera <tyrell.perera@gmail.com>
Licensed under the MIT license.
