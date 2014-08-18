# == Class: lvs::ldap::server
#
# This construction class installs and configures the LVS
# for LDAP load-balancer function.
#
# Supported OSses and versions:
# * CentOS
#   * 6
# * RHEL
#   * 6
#
# === Dependencies
#
# iptables::filterdportfile
# iptables::nat, only behind LVS
# lvs::ldap::install
# lvs::ldap::client
#
# === Parameters
#
# All parameters used as an configuration interface are
# placed in the lvs::ldap::params class.
#
# === Variables
#
# === Authors
#
# Allard Berends <allard.berends@example.com> (AB)
#
# === Copyright
#
# Copyright 2014 Allard Berends
#
class lvs::ldap::server inherits lvs::ldap::params {
  include iptables
  include lvs::service
  require lvs::install

  selboolean {'piranha_lvs_can_network_connect':
    persistent => true,
    value      => 'on',
  }

  file {$lvs_cf:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0660',
    content => template('lvs/ldap/lvs.cf.erb'),
    notify  => Service[$lvs::service::services],
    require => Selboolean['piranha_lvs_can_network_connect'],
  }

  file {"$check_dir/$check_ds":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('lvs/ldap/check_ds.erb'),
    notify  => Service[$lvs::service::services],
    require => Selboolean['piranha_lvs_can_network_connect'],
  }

  if $encryption == 'yes' {
    file {"$check_dir/$check_ds_ssl":
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template('lvs/ldap/check_ds_ssl.erb'),
      notify  => Service[$lvs::service::services],
      require => Selboolean['piranha_lvs_can_network_connect'],
    }
  } # if

  $iptables_lines.each |$entry|{
    $dummy = sprintf('%05.5d_%s_%s',
      $entry['dport'],
      $entry['protocol'],
      $title)
    iptables::filterdportfile {"${iptables::install::filter_dport_dir}/${dummy}":
      comment  => $entry['comment'],
      dport    => $entry['dport'],
      protocol => $entry['protocol'],
      before   => Class['iptables'],
    }
  } # end each
} # end lvs::ldap::server
