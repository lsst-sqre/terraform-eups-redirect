include ::stdlib
include ::augeas
include ::nginx

class { 'timezone': timezone  => 'US/Pacific' }

# $pkgs = ['git', 'tree', 'vim-enhanced', 'ack', 'rsync']
# ensure_packages($pkgs)

$redirect_host       = hiera('redirect_host', 'eups-redirect.lsst.codes')
$eupspkg_host        = hiera('eupspkg_host', 'eups.lsst.codes')
$redirect_access_log = "/var/log/nginx/${redirect_host}.access.log"
$redirect_error_log  = "/var/log/nginx/${redirect_host}.error.log"

selboolean { 'httpd_can_network_connect':
  value      => on,
  persistent => true,
}

selboolean { 'httpd_setrlimit':
  value      => on,
  persistent => true,
}

# If SSL is enabled and we are catching an DNS cname, we need to redirect to
# the canonical https URL in one step.  If we do a http -> https redirect, as
# is enabled by puppet-nginx's rewrite_to_https param, the the U-A will catch
# a certificate error before getting to the redirect to the canonical name.
$redirect_raw_prepend = [
  "if ( \$host != \'${eupspkg_host}\' ) {",
  "  rewrite ^/eupspkg/(.*)$ https://${eupspkg_host}/stack/src/\$1 last;",
  '}',
]

nginx::resource::vhost { $redirect_host:
  ensure               => present,
  server_name          => [
    $redirect_host,
    'sw.lsstcorp.org',
  ],
  listen_port          => 80,
  listen_options       => 'default_server',
  ssl                  => false,
  access_log           => $redirect_access_log,
  error_log            => $redirect_error_log,
  rewrite_to_https     => false,
  use_default_location => false,
  index_files          => [],
  # see comment above $raw_prepend declaration
  raw_prepend          => $redirect_raw_prepend,
}
