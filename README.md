## A GitLab CE base image to run a GitLab CE instance

This project contains a Docker image that can be used as a base image to create a new Docker image customised for your environment.


### Building the Docker image yourself and hosting it

  1. Clone this repository.
  2. Build the Docker image.

     `docker build -t <your-docker-repo>/centos-gitlab-ce:latest .`

  3. Deploy the image to your repository

      `docker push <your-docker-repo>/centos-gitlab-ce:latest`


### Running this image for verification and troubleshooting

This image is not intended to be run as a GitLab instance, since the configuration is left untouched as is. However, if you want to run the image to inspect the GitLab installation and the container environment, you can do so by running the following command.

      `docker run -i -t tyrell/centos-gitlab-ce:latest /bin/bash`

Once inside the container, gitlab-ctl command can be used to verify the default configuration.

      `gitlab-ctl show-config` or `vi /opt/gitlab/etc/gitlab.rb.template`


### Using this base image to create a configured GitLab instance for yourself

This base image can be used to create an image configured to match your local instance. I have hosted an image at https://cloud.docker.com/repository/docker/tyrell/centos-gitlab-ce at the time of writing. Please check the image TAG for the GitLab CE version being used.

My recommended option is to build this Docker file to get the latest GitLab CE baked in to a new image and host it in your repo. Use another Dockerfile to copy your GitLab configurations and other modifications. This will keep the GitLab base installation de-coupled from your environment specific configurations. With this option, you will be able to patch GitLab independently, for most updates.

  1. Configure GitLab for your system by using your own /etc/gitlab/gitlab.rb file
  2. Run reconfigure.

      `gitlab-ctl reconfigure`    


### License
Copyright (c) 2017 Tyrell Perera <tyrell.perera@gmail.com>
Licensed under the MIT license.
