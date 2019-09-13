# Docker options
## Prevent Postgres from trying to allocate 25% of total memory
postgresql['shared_buffers'] = '1MB'

# Disable Prometheus node_exporter inside Docker.
node_exporter['enable'] = false

# Manage accounts with docker
manage_accounts['enable'] = false

# Under restricted permissions, prometheus won't be able to list nodes at the cluster scope: no RBAC policy matched"
# and will get the error: Failed to list *v1.Node: nodes is forbidden: User \"system:serviceaccount:test-gitlab:default\" 
prometheus_monitoring['enable'] = false

# Get hostname from shell
host = `hostname`.strip
external_url "http://#{host}"

# Explicitly disable init detection since we are running on a container
package['detect_init'] = false

# external connections need to be in the root group to have access to the 
# git-workhorse socket at /var/opt/gitlab/gitlab-workhorse/socket
# when gitlab-ctl reconfigure is called, this will update conf/nginx.conf 
web_server['group'] = 'root'

# Load custom config from environment variable: GITLAB_OMNIBUS_CONFIG
# Disabling the cop since rubocop considers using eval to be security risk but
# we don't have an easy way out, atleast yet.
eval ENV["GITLAB_OMNIBUS_CONFIG"].to_s # rubocop:disable Security/Eval

# Load configuration stored in /etc/gitlab/gitlab.rb
from_file("/etc/gitlab/gitlab.rb")