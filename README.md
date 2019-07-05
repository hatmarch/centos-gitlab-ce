## A GitLab CE base image to run a GitLab CE instance

This project contains a Docker image that can be used as a base image to create a new Docker image customised for your environment.

The included docker-build-output.txt file contains logs from a test image build.


### Building the Docker image yourself and hosting it

  1. Clone this repository.
  2. Build the Docker image.

     `docker build -t <your-docker-repo>/centos-gitlab-ce .`

  3. Deploy the image to your repository

     `docker push <your-docker-repo>/centos-gitlab-ce:latest`


### Using this base image to create a configured GitLab instance for yourself

This base image can be used to create an image configured to match your local instance.

  1. Configure GitLab for your system by using your ownw /etc/gitlab/gitlab.rb file
  2. Run reconfigure.

      `gitlab-ctl reconfigure`    


### License
Copyright (c) 2017 Tyrell Perera <tyrell.perera@gmail.com>
Licensed under the MIT license.
