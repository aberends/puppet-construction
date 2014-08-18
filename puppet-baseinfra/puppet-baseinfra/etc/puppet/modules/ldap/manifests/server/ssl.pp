# == Class: ldap::server::ssl
#
# This helper class configures SSL on the LDAP server. We
# need the following items:
# * CA keypair file
# * pin file
# * SSL LDIF file
#
# By importing the keypair in the security database, the
# LDAP server can run in SSL mode. For startup, the password
# for unlocking the keypair is needed.
#
# By running the SSL LDIF file on the current running LDAP
# server configuration, the SSL mode is switched on. To
# effectuate the SSL settings, the LDAP server needs to be
# restarted.
#
# === Dependencies
#
# ldap::server
#
# === Parameters
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
# === Bugs
#
# This helper class is not capable of dealing with a change.
# If run for a second time, the ldapmodify command fails,
# because some entries are already in the LDAP database.
# This should be solved in a custom type that knows how to
# deal with the presence of items in the LDAP database.
class ldap::server::ssl inherits ldap::server::params {
  # AB: step 1: import CA keypair.
  file {$capem_file:
    ensure  => file,
    owner   => 'nobody',
    group   => 'nobody',
    mode    => '0400',
    content => $capem,
    require => Service[$services],
  }

  file {$root_dn_pwd_file:
    ensure  => file,
    owner   => 'nobody',
    group   => 'nobody',
    mode    => '0400',
    content => "${root_dn_pwd}\n${root_dn_pwd}",
    require => Service[$services],
  }

  exec {'import_capem':
    command => "/usr/bin/openssl pkcs12 -export -in $capem_file -out $cap12_file -passin file:$root_dn_pwd_file -passout file:$root_dn_pwd_file -name \"LDAP CA cert\" && /usr/bin/pk12util -i $cap12_file -d $slapd_path -w $root_dn_pwd_file -k $root_dn_pwd_file && /usr/bin/certutil -d $slapd_path -n \"LDAP CA cert\" -M -t CTu,u,u && /bin/touch $capem_run",
    onlyif  => "/usr/bin/test $capem_file -nt $capem_run",
    require => File[
      $capem_file,
      $root_dn_pwd_file
    ],
  }

  # AB: step 2: generate server keypair
  file {$nss_noise:
    ensure  => file,
    owner   => 'nobody',
    group   => 'nobody',
    mode    => '0400',
    source  => 'puppet:///modules/ldap/server/noise.txt',
    require => Service[$services],
  }

  exec {'gen_srv_keypair':
    command => "/usr/bin/certutil -S -n \"LDAP server cert\" -s \"cn=$server_cn\" -c \"LDAP CA cert\" -t \"u,u,u\" -m 1001 -v 120 -d $slapd_path -k rsa -g 1024 -f $root_dn_pwd_file -z $nss_noise && /bin/touch $srv_keypair_run",
    onlyif  => "/usr/bin/test $capem_file -nt $srv_keypair_run",
    require => [File[$nss_noise], Exec['import_capem']],
  }

  # AB: step 3: modify SSL settings
  file {$ssl_ldif:
    ensure  => file,
    owner   => 'nobody',
    group   => 'nobody',
    mode    => '0400',
    source  => 'puppet:///modules/ldap/server/modify_ssl.ldif',
    require => Exec['gen_srv_keypair'],
  }

  file {$ssl_pin:
    ensure  => file,
    owner   => 'nobody',
    group   => 'nobody',
    mode    => '0400',
    content => template('ldap/server/pin.txt.erb'),
    require => Exec['gen_srv_keypair'],
  }

  exec {'modify_ssl':
    command => "/usr/bin/ldapmodify -H ldap://localhost -D \"$root_dn\" -w $root_dn_pwd -f $ssl_ldif && /sbin/service dirsrv restart && /bin/touch $ssl_ldif_run",
    onlyif  => "/usr/bin/test $ssl_ldif -nt $ssl_ldif_run",
    require => File[
      $ssl_ldif,
      $ssl_pin
    ],
  }

} # end ldap::server::ssl
