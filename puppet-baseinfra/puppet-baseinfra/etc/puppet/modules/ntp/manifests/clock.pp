# == Class: ntp::clock
#
# This construction class installs and configures the NTP
# clock function.
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
# placed in the ntp::clock::params class.
#
# === Variables
#
# === Examples
#
#  include ntp::clock
#
# === Authors
#
# Allard Berends <allard.berends@example.com>
#
# === Copyright
#
# Copyright 2014 Allard Berends
#
class ntp::clock inherits ntp::clock::params {
  include iptables

  package {$ntp_packages:
    ensure  => 'installed',
  }

  file {'/etc/ntp.conf':
    ensure    => file,
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    source    => "puppet:///modules/ntp/clock",
    require   => Package[$ntp_packages],
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
} # end ntp::clock
