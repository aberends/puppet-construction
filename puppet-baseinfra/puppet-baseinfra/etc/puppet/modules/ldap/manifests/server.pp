# == Class: ldap::server
#
# This construction class installs and configures the LDAP
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
# iptables::nat, only behind LVS
# ldap::client
#
# === Parameters
#
# All parameters used as an configuration interface are
# placed in the ldap::server::params class.
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
class ldap::server inherits ldap::server::params {
  include iptables
  require ldap::client

  rhn_channel{$rhn_channel:}

  package{$srv_packages:
    ensure  => 'installed',
    require => Rhn_channel[$rhn_channel],
  }

  $setup_ds = 'setup_ds'

  # AB: step 1: installation
  file {$setup_inf:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('ldap/server/setup.erb'),
    require => Package[$srv_packages],
  }

  file {$limits:
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/ldap/server/90-nofile.conf'
  }

  exec {$setup_ds:
    command => "/usr/sbin/setenforce 0 && /usr/sbin/setup-ds-admin.pl --silent --file=${setup_inf} && /usr/sbin/setenforce 1",
    onlyif  => '/usr/bin/test ! -f /etc/dirsrv/admin-serv/adm.conf',
    require => File[
      $setup_inf,
      $limits
    ],
    before  => Service[$services],
  }

  service {$services:
    ensure => 'running',
    enable => true,
    require => Exec[$setup_ds],
  }

  # AB: step 2: timeout configuration
  file {$idle_timeout_ldif:
    ensure  => file,
    owner   => 'nobody',
    group   => 'nobody',
    mode    => '0644',
    content => template("ldap/server/idle_timeout.ldif.erb"),
    require => Service[$services],
  }

  # AB: do we need an LDAP restart?
  exec {'set_timeout':
    command => "/usr/bin/ldapmodify -H ldap://localhost -D \"$root_dn\" -w \"$root_dn_pwd\" -f $idle_timeout_ldif && /bin/touch $idle_timeout_run",
    onlyif  => "/usr/bin/test $idle_timeout_ldif -nt $idle_timeout_run",
    require => File[$idle_timeout_ldif],
  }

  # AB: step 3: iptables configuration
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

  if size($ldap_vname) > 0 {
    $iptables_nat.each |$entry|{
      $dummy_nat = sprintf('%05.5d_%s_%s',
        $entry['dport'],
        $entry['protocol'],
        $title)
      iptables::natfile{"${iptables::install::nat_dir}/${dummy_nat}":
        chain    => $entry['chain'],
        comment  => $entry['comment'],
        dip      => $entry['dip'],
        dport    => $entry['dport'],
        protocol => $entry['protocol'],
        before   => Class['iptables'],
      }
    } # end each
  } # ldap_vname > 0

  # AB: step 4: check if ssl is needed
  if $ssl == 'yes' {
    include ldap::server::ssl
  } # ssl yes

  # AB: step 5: check if mmr is needed
  if $mmr == 'yes' {
    include ldap::server::mmr
  } # mmr yes
} # end ldap::server
