# == Class: ldap::client
#
# This construction class installs and configures the LDAP
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
# ldap::install
#
# === Parameters
#
# All parameters used as an configuration interface are
# placed in the ldap::params class.
#
# === Variables
#
# === Examples
#
# In YAML file:
# ldap::params::cacert_value: |
#  -----BEGIN CERTIFICATE-----
#  .
#  .
#  k7IJPVN+jDH9heNcZQIDAQABoxYwFDASBgNVHRMBAf8ECDAGAQH/AgEAMA0GCSqG
#  SIb3DQEBBQUAA4IBAQCXOuSeEkKDZ178T5DVxqmuotbmFW5I+lQhA7Y5dgpy4MwA
#  .
#  .
#  -----END CERTIFICATE-----
# ldap::params::ldap_domain: "dmsat1.org"
# ldap::params::servers:
#  - "ds.dmsat1.org"
#
# In puppet code:
# include ldap::client
#
# Or in site.pp:
# hiera_include('classes')
# and (for this case) in YAML:
# classes:
#  - ldap::client
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
# We set nsswitch.conf in this module explicitly. Instead,
# it must be configurable. It is up to the node how to
# configure nsswitch.conf, not to the ldap client. The ldap
# client should only demand that for a specific set of name
# databases (e.g. passwd, shadow, and group), ldap is used.
# Now, we dictate the whole file, which is wrong.
class ldap::client inherits ldap::client::params {
  include stdlib

  package{$client_packages:
    ensure => 'installed',
  }

  # The LDAP client also supports RHEL 5. Since, Mozilla
  # LDAP is the preferred set of client tools for RHEL 5,
  # we configure it here.
  if $::operatingsystemmajrelease == '5' {
    file {'/etc/profile.d/mozldap.sh':
      ensure    => file,
      owner     => 'root',
      group     => 'root',
      mode      => '0644',
      source    => 'puppet:///modules/ldap/client/mozldap.sh',
      require   => Package[$client_packages],
    }
    file {'/etc/ldap.conf':
      ensure    => file,
      owner     => 'root',
      group     => 'root',
      mode      => '0644',
      content   => template('ldap/client/mozldap.erb'),
      require   => Package[$client_packages],
    }
  } # ::operatingsystemmajrelease == 5

  file {'/etc/nslcd.conf':
    ensure    => file,
    owner     => 'root',
    group     => 'root',
    mode      => '0600',
    content   => template('ldap/client/nslcd.erb'),
    require   => Package[$client_packages],
  }

  file {'/etc/openldap/ldap.conf':
    ensure    => file,
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    content   => template('ldap/client/openldap.erb'),
    require   => Package[$client_packages],
  }

  file {'/etc/pam_ldap.conf':
    ensure    => file,
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    content   => template('ldap/client/pam_ldap.erb'),
    require   => Package[$client_packages],
  }

  file {'/etc/nsswitch.conf':
    ensure    => file,
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    source    => "puppet:///modules/ldap/client/nsswitch.${::operatingsystemmajrelease}",
    require   => Package[$client_packages],
  }

  file {'/etc/pam.d/system-auth-ac':
    ensure    => file,
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    source    => 'puppet:///modules/ldap/client/system-auth-ac',
    require   => Package[$client_packages],
  }

  if $encrypted == 'yes' {
    # GW: On RHEL 5 the rights are 0755. Setting it here to
    # 0700 shouldn't be a problem, but I mention it just in
    # case.
    file {$cacert_dir:
      ensure    => directory,
      owner     => 'root',
      group     => 'root',
      mode      => '0700',
      require   => Package[$client_packages],
    }

    file {$cacert_file:
      ensure    => file,
      owner     => 'root',
      group     => 'root',
      mode      => '0644',
      content   => $cacert_value,
      require   => File[$cacert_dir],
      notify    => Exec['cert_symlink'],
    }

    exec {'cert_symlink':
      command   => "/bin/ln -sf my-ca.crt ${cacert_dir}/$(/usr/bin/openssl x509 -in ${cacert_file} -noout -hash).0",
      cwd       => $cacert_dir,
      require   => File[$cacert_file],
    }
  } # if encrypted
} # end ldap::client
