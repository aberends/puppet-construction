# == Class: ldap::server::mmr
#
# This helper class configures MMR (MultiMaster Replication)
# on the LDAP server. We need the following items:
# * MMR LDIF file
#
# By running the MMR LDIF file on the current running LDAP
# server configuration, the MMR mode is switched on. To
# effectuate the MMR settings, the generated script must be
# run on either of the LDAP servers.
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
class ldap::server::mmr inherits ldap::server::params {
  # AB: make sure that we cannot be stopped by the SSL
  # changes. SSL needs a restart of LDAP. So, if SSL is
  # configured, we depend on it. Else, we depend on a
  # running LDAP server.
  if $ssl == 'yes' {
    require ldap::server::ssl
  }

  # AB: step 1: modify MMR settings
  file {$mmr_ldif:
    ensure  => file,
    owner   => 'nobody',
    group   => 'nobody',
    mode    => '0400',
    content => template('ldap/server/mmr.ldif.erb'),
    require => Service[$services],
  }

  exec {'modify_mmr':
    command => "/usr/bin/ldapmodify -H ldap://localhost -D \"$root_dn\" -w $root_dn_pwd -f $mmr_ldif && /bin/touch $mmr_ldif_run",
    onlyif  => "/usr/bin/test $mmr_ldif -nt $mmr_ldif_run",
    require => File[
      $mmr_ldif,
      $ssl_pin
    ],
  }

  # AB: step 2: generate start replication script
  file {$start_replication:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '750',
    content => template('ldap/server/start-replication.sh.erb'),
    require => Exec['modify_mmr'],
  }
} # end ldap::server::mmr
