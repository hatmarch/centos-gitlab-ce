
These commands are from the blog post found at https://blog.openshift.com/getting-any-docker-image-running-in-your-own-openshift-cluster/

# oc new-project gitlab

  Now using project "gitlab" on server "https://api.your-osd.openshift.com:443".

  You can add applications to this project with the 'new-app' command. For example, try:

      oc new-app centos/ruby-22-centos7~https://github.com/openshift/ruby-ex.git

  to build a new example application in Ruby.

# oc new-app gitlab/gitlab-ce
    --> Found Docker image 91ae3a8 (5 days old) from Docker Hub for "gitlab/gitlab-ce"
    * An image stream will be created as "gitlab-ce:latest" that will track this image
    * This image will be deployed in deployment config "gitlab-ce"
    * [WARNING] Image "gitlab-ce" runs as the 'root' user which may not be permitted by your cluster administrator
    * Ports 22/tcp, 443/tcp, 80/tcp will be load balanced by service "gitlab-ce"
    --> Creating resources with label app=gitlab-ce ...
    ImageStream "gitlab-ce" created
    DeploymentConfig "gitlab-ce" created
    Service "gitlab-ce" created
    --> Success
    Run 'oc status' to view your app.

# oc get pods
    NAME                READY     STATUS             RESTARTS   AGE
    gitlab-ce-1-kekx2   0/1       CrashLoopBackOff   4          5m

# oc logs -p gitlab-ce-1-kekx2

    Thank you for using GitLab Docker Image!
    Current version: gitlab-ce=8.4.3-ce.0

    Configure GitLab for your system by editing /etc/gitlab/gitlab.rb file
    And restart this container to reload settings.
    To do it use docker exec:

    docker exec -it gitlab vim /etc/gitlab/gitlab.rb
    docker restart gitlab

    For a comprehensive list of configuration options please see the Omnibus GitLab readme
    https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/README.md

    If this container fails to start due to permission problems try to fix it by executing:

    docker exec -it gitlab update-permissions
    docker restart gitlab

    Generating ssh_host_rsa_key...
    No user exists for uid 1000530000
