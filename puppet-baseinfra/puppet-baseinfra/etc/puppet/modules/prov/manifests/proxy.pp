# == Class: prov::proxy
#
# This construction class installs and configures the
# Spacewalk proxy function.
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
# placed in the prov::proxy::params class.
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
class prov::proxy inherits prov::proxy::params {
  include iptables

  # AB: $rhn_channels must come from YAML files!
  rhn_channel{$rhn_channels:}

  package{$proxy_packages:
    ensure  => 'installed',
    require => Rhn_channel[$rhn_channels],
  }

  $answer_file      = '/root/proxy-answers.txt'
  $setup_proxy      = 'setup_proxy'
  $setup_proxy_done = '/root/setup_proxy.done'
  $ssl_build        = '/root/ssl-build'

  # AB: step 1: installation
  file {$ssl_build:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file {"${ssl_build}/rhn-ca-openssl.cnf":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template("prov/proxy/rhn-ca-openssl.cnf.erb"),
    require => File[$ssl_build],
  }

  file {"${ssl_build}/RHN-ORG-PRIVATE-SSL-KEY":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => $private_ssl_key,
    require => File[$ssl_build],
  }

  file {"${ssl_build}/RHN-ORG-TRUSTED-SSL-CERT":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $trusted_ssl_cert,
    require => File[$ssl_build],
  }

  file {$answer_file:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("prov/proxy/proxy-answers.txt.erb"),
    require => File[$ssl_build],
  }

  exec {$setup_proxy:
    command => "/usr/sbin/configure-proxy.sh --answer-file=${answer_file} && /bin/touch ${setup_proxy_done}",
    onlyif  => "/usr/bin/test ! -f ${setup_proxy_done}",
    require => [
      File[$answer_file],
      Package[$proxy_packages]
    ],
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

} # end prov::proxy
