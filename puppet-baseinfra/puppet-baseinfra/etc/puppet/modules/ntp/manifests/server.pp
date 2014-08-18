# == Class: ntp::server
#
# This construction class installs and configures the NTP
# server function.
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
# placed in the ntp::server::params class.
#
# === Variables
#
# === Examples
#
#  include ntp::server
#
# === Authors
#
# Allard Berends <allard.berends@example.com>
#
# === Copyright
#
# Copyright 2014 Allard Berends
#
class ntp::server inherits ntp::server::params {
  include iptables

  package {$ntp_packages:
    ensure  => 'installed',
  }

  if $::operatingsystemmajrelease == '6' {
    package {$ntp_packages6:
      ensure  => 'installed',
    }
  } # if

  file {'/etc/ntp.conf':
    ensure    => file,
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    content   => template('ntp/server/ntp_conf.erb'),
    require   => Package[$ntp_packages],
  }

  # AB: note ntpdate is shared by client and server.
  if $::operatingsystemmajrelease == '6' {
    file {'/etc/sysconfig/ntpdate':
      ensure    => file,
      owner     => 'root',
      group     => 'root',
      mode      => '0644',
      source    => "puppet:///modules/ntp/ntpdate",
      require   => Package[$ntp_packages6],
    }

    service {$ntp_services6:
      ensure    => 'running',
      enable    => true,
      subscribe => File['/etc/sysconfig/ntpdate'],
    }
  }

  file {'/etc/sysconfig/ntpd':
    ensure    => file,
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    source    => "puppet:///modules/ntp/ntpd.${::operatingsystemmajrelease}",
    require   => Package[$ntp_packages],
  }

  service {$ntp_services:
    ensure    => 'running',
    enable    => true,
    subscribe => File[
      '/etc/ntp.conf',
      '/etc/sysconfig/ntpd'
    ],
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
} # end ntp::server
