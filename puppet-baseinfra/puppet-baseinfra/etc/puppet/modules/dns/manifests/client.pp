# == Class: dns::client
#
# This construction class installs and configures the DNS
# client function.
#
# Supported OSses and versions:
# * CentOS
#   * 5
#   * 6
# * RHEL
#   * 5
#   * 6
#
# === Dependencies
#
# stdlib
#
# === Parameters
#
# All parameters used as an configuration interface are
# placed in the dns::client::params class.
#
# === Variables
#
# === Examples
#
# In YAML file:
# dns::client::params::domain: "svcs.dmsat1.org"
# dns::client::params::search: "svcs.dmsat1.org"
# dns::client::params::servers:
#  - "dns1.svcs.dmsat1.org"
#  - "dns2.svcs.dmsat1.org"
#  - "dns3.svcs.dmsat1.org"
#
# In puppet code:
# include dns::client
#
# === Authors
#
# Allard Berends <allard.berends@example.com> (AB)
#
# === Copyright
#
# Copyright 2014 Allard Berends
#
# === Bugs
#
class dns::client inherits dns::client::params {

  # AB: /etc/resolv.conf comes from glibc, so no separate
  # RPM's needed.
  file {'/etc/resolv.conf':
    ensure    => file,
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    content   => template('dns/client/resolv.conf.erb'),
  }

} # end dns::client
