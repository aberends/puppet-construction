# == Class: support6
#
# This construction class installs a set of tools to support6
# efficient system administration.
#
# It is paramount not to install services here. Services
# need configuration. We don't do any configuration here.
#
# Supported OSses and versions:
# * CentOS
#   * 6
# * RHEL
#   * 6
#
# === Parameters
#
# All parameters used as an configuration interface are
# placed in the support6::params class.
#
# === Variables
#
# === Examples
#
#  include support6
#
# === Authors
#
# Allard Berends <allard.berends@example.com> (AB)
#
# === Copyright
#
# Copyright 2014 Allard Berends
#
class support6 inherits support6::params {
  if size($rpms) > 0 {
    package {$rpms:
      ensure => 'installed',
    }
  } # if

  if $want_bashrc == 'yes' {
    file {'/root/.bashrc':
      ensure    => file,
      owner     => 'root',
      group     => 'root',
      mode      => '0644',
      source    => 'puppet:///modules/support6/bashrc',
    }
  } # if
} # end support6
