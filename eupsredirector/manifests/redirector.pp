include ::stdlib
include ::augeas
include ::nginx

class { 'timezone': timezone  => 'US/Pacific' }

$pkgs = ['git', 'tree', 'vim-enhanced', 'ack', 'rsync']
ensure_packages($pkgs)
# ensure_packages() doesn't work correctly with resource collector deps

$eupspkg_host       = hiera('eupspkg_host', 'eupspkg-test')
$eupspkg_access_log = "/var/log/nginx/${eupspkg_host}.access.log"
$eupspkg_error_log  = "/var/log/nginx/${eupspkg_host}.error.log"

if $ssl_cert and $ssl_key {
  $enable_ssl = true
}

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
$eupspkg_raw_prepend = [
  "if ( \$host != \'${eupspkg_host}\' ) {",
  "  return 301 https://${eupspkg_host}\$request_uri;",
  '}',
]

nginx::resource::vhost { $eupspkg_host:
  ensure               => present,
  server_name          => [
    $eupspkg_host,
    'sw.lsstcorp.org',
  ],
  listen_port          => 80,
  ssl                  => false,
  access_log           => $eupspkg_access_log,
  error_log            => $eupspkg_error_log,
  rewrite_to_https     => false,
  use_default_location => false,
  index_files          => [],
  # see comment above $raw_prepend declaration
  raw_prepend          => $eupspkg_raw_prepend,
}
