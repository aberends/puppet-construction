# == Class: ldap::client::params
#
# This interface class provides the configuration interface
# of the ldap client module. All other classes in the ldap
# client module inherit these class parameters.
#
# The default values of the parameters can be overridden in
# YAML files. All the paremters are validated in this class.
#
# === Dependencies
#
# === Parameters
#
# *cacert_dir*
#   Default: '/etc/openldap/cacerts'
#
#   Directory where the LDAP client tools check the CA
#   certificates.
# *cacert_value*
#   Default: '' (empty string)
#
#   The base64 encoded value of the X.509v3 certificate of
#   the CA (Certificate Authority) in this depzone. This
#   parameter must be provided from a YAML file. It has no
#   default value.
# *encrypted*
#   Default: 'yes'
#
#   Whether the LDAP client connections must be encrypted
#   with TLS.
# *ldap_domain*
#   Default: None
#
#   The LDAP domain used by the clients and server. In the
#   sever, the backend database uses the LDAP domain as a
#   suffix. For example: dc=example,dc=com
# *servers*
#   Default: None
#
#   Array of hashes with information about ldap servers. For
#   most client systems, this is an array with one element.
#   If this array contains 2 or more elements, then these
#   elements are used to setup multiple LDAP servers in the
#   client configuration files.
#
# === Variables
#
# *cacert_file*
#   File my-ca.crt in $cacert_dir.
#   File containing the X.509v3 certificate of the LDAP
#   server in this depzone.
# *client_packages*
#   Packages needed for LDAP clients. Its value depends on
#   the OS major version.
#
# === Examples
#
# === Authors
#
# Allard Berends <allard.berends@example.com> (AB)
#
# === History
#
# === Copyright
#
# Copyright 2014 Allard Berends
#
# === Bugs
#
# The naming of this module is wrong. It suggests that we
# are general, but we are not. We implement the 389
# Directory Server project, which is the upstream project of
# the RHDS (Red Hat Directory Server), and the RHDS.
class ldap::client::params (
  $cacert_dir          = '/etc/openldap/cacerts',
  $cacert_value        = '',
  $encrypted           = 'yes',
  $ldap_domain,
  $servers,
) {
  include stdlib
  # AB: code here must have not side effects. Only setting
  # of variables is allowed!

  # AB: validate class parameters.
  case $::puppetversion {
    /^3\.[6789].*/: {
      fail("Puppet version ${::puppetversion} not yet implemented.")
    } # puppet >= 3.6 and < 4.0

    /^3\.[012345].*/: {
      validate_string($encrypted)
      unless $encrypted in ['yes', 'no'] {
        fail("${title}::\$encrypted not set")
      }
      validate_string($ldap_domain)
      unless is_domain_name($ldap_domain) {
        fail("${title}::\$ldap_domain not set")
      }
      validate_array($servers)
      if size($servers) == 0 {
        fail("${title}::\$servers not set")
      }
      unless is_domain_name($servers[0]) {
        fail("${title}::\$servers first element not set")
      }

      # AB: encrypted specific parameter check.
      if $encrypted == 'yes' {
        validate_string($cacert_dir)
        if size($cacert_dir) == 0 {
          fail("${title}::\$cacert_dir not set")
        }
        validate_string($cacert_value)
        if size($cacert_value) == 0 {
          fail("${title}::\$cacert_value not set")
        }
      } # encrypted is yes
    } # puppet >= 3.0 and < 3.6

    default: {
      fail("Puppet version ${::puppetversion} not supported.")
    } # unsupported puppet versions
  } # case

  # AB: calculated variables
  $cacert_file = "${cacert_dir}/my-ca.crt"
  case $::operatingsystemmajrelease {
    '5': {
      $client_packages = ['mozldap-tools','openldap-clients', 'nss_ldap']
    }

    # AB: if this list is adapted, the blacklist in support6
    # must be adapted too!
    '6': {
      $client_packages = ['openldap-clients', 'nss-pam-ldapd', 'nscd']
    }

    default: {
      fail("Module ${module_name} is not supported on RHEL ${::operatingsystemmajrelease}")
    }
  }
} # end ldap::client::params
