# == Class: dns::server
#
# This construction class installs and configures the DNS
# server function.
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
#
# === Parameters
#
# All parameters used as an configuration interface are
# placed in the dns::server::params class.
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
class dns::server inherits dns::server::params {
  include iptables

  package{$srv_packages:
    ensure  => 'installed',
  }

  $create_zones      = 'create_zones'
  $create_zones_done = '/root/create_zones.done'
  $depzones_path     = '/var/lib/hiera/depzones'
  $named_db_dir      = '/var/named/chroot/var/named'
  $named_conf_dir    = '/var/named/chroot/etc'
  $rngd_sysconfig    = '/etc/sysconfig/rngd'

  file {$rngd_sysconfig:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    source  => 'puppet:///modules/dns/server/rngd',
    require => Package[$srv_packages],
  }

  service {'rngd':
    ensure  => 'running',
    enable  => true,
    require => File[$rngd_sysconfig],
  }

  file {"${named_db_dir}/data":
    ensure  => directory,
    owner   => 'named',
    group   => 'named',
    mode    => '0755',
    require => Package[$srv_packages],
  }

  file {"${named_db_dir}/named.ca":
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/dns/server/named.ca',
    require => Package[$srv_packages],
  }

  file {"${named_db_dir}/named.empty":
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/dns/server/named.empty',
    require => Package[$srv_packages],
  }

  file {"${named_db_dir}/named.localhost":
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/dns/server/named.localhost',
    require => Package[$srv_packages],
  }

  file {"${named_db_dir}/named.loopback":
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/dns/server/named.loopback',
    require => Package[$srv_packages],
  }

  file {"${named_conf_dir}/named.rfc1912.zones":
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/dns/server/named.rfc1912.zones',
    require => Package[$srv_packages],
  }

  file {"${named_conf_dir}/named.conf":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dns/server/named.conf.erb'),
    require => Package[$srv_packages],
  }

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

  if $auto_zone == 'yes' {
    $tools_rpm = 'puppet-tools'
    if $depz {
      $dz = $depz
    } else {
      $dz = $depzone
    }

    # AB: $tools_channel must come from YAML files!
    rhn_channel {$tools_channel:}

    package{$tools_rpm:
      ensure  => 'installed',
      require => Rhn_channel[$tools_channel],
    }

    exec {$create_zones:
      command => "/usr/bin/mk_zones_from_yaml.py -n ${fqdn} ${depzones_path}/${dz}/hosts && /bin/touch ${create_zones_done}",
      onlyif  => "/usr/bin/test ! -f ${create_zones_done}",
      require => Package[$tools_rpm, $srv_packages],
    }

    service {'named':
      ensure  => 'running',
      enable  => true,
      require => Exec[$create_zones],
    }

  } # if
} # end dns::server
