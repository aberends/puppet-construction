# == Class: prov::proxy::params
#
# This interface class provides the configuration interface
# of the Spacewalk proxy module. All other classes in the
# Spacewalk proxy module inherit these class parameters.
#
# The default values of the parameters can be overridden in
# YAML files. All the parameters are validated in this
# class.
#
# === Dependencies
#
# The functioning of the Spacewalk proxy module depends on
# configuration of the Spacewalk/Satellite server software
# channels. See the rhn_channels parameter.
#
# === Parameters
#
# *cakey_passwd*
#   Default: empty
#
#   The plaintext password with which the base64 encoded
#   private key of the Spacewalk/Satellite CA is encrypted.
# *country_code*
#   Default: empty
#
#   The 2 letter ISO 3166-1 country code. NL for the
#   Netherlands.
# *iptables_lines*
#   Default: [
#     {
#       'protocol' => 'tcp',
#       'dport'    => 80,
#       'comment'  => 'HTTP',
#     },
#     {
#       'protocol' => 'tcp',
#       'dport'    => 443,
#       'comment'  => 'HTTPS',
#     },
#     {
#       'protocol' => 'tcp',
#       'dport'    => 5222,
#       'comment'  => 'JABBERD',
#     },
#   ]
#
#  The TCP ports to be opened in the host's firewall to
#  support provisioning on HTTP, HTTP over SSL (HTTPS),
#  strictly spoken TLS, and the jabberd traffic.
# *locality*
#   Default: empty
#
#   The city on the Spacewalk/Satellite server certificate.
#   It is an input parameter for the server certificate
#   generation.
# *organization*
#   Default: empty
#
#   The organization on the Spacewalk/Satellite server
#   certificate. It is an input parameter for the server
#   certificate generation.
# *organizational_unit*
#   Default: empty
#
#   The organizational_unit on the Spacewalk/Satellite
#   server certificate. It is an input parameter for the
#   server certificate generation.
# *private_ssl_key*
#   Default: empty
#
#   The base64 encoded private key of the
#   Spacewalk/Satellite CA. It is used to sign the
#   Spacewalk/Satellite proxy's server certificate.
# *proxy_version*
#   Default: empty
#
#   The version of the Spacewalk/Satellite proxy used.
# *rhn_channels*
#   Default: empty
#
#   Label of the Spacewalk/Satellite software channels in
#   which the RPM's and supporting RPM's for the Spacewalk
#   proxy are located.
# *sat_user*
#   Default: empty
#
#   The account on the Spacewalk/Satellite organization via
#   which one can register new software channels.
# *sat_passwd*
#   Default: empty
#
#   The password of sat_user.
# *state*
#   Default: empty
#
#   The state on the Spacewalk/Satellite server certificate.
#   It is an input parameter for the server certificate
#   generation.
# *trusted_ssl_cert*
#   Default: empty
#
#   The X.509v3 base64 encoded certificate of the
#   Spacewalk/Satellite server. If the Satellite server is
#   reinstalled or the CA certificate of the Satellite
#   server is changed, this parameter needs to get that new
#   certificate.
#
# === Variables
#
# *ssl_pin*
#   File pin.txt in $slapd_path.
#   This file contains the pin code, needed for the slapd
#   process to unlock the security database file in
#   $slapd-path (cert8.db, key3.db, secmod.db)
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
class prov::proxy::params (
  $cakey_passwd,
  $country_code,
  $iptables_lines      = [
    {
      'protocol' => 'tcp',
      'dport'    => 80,
      'comment'  => 'HTTP',
    },
    {
      'protocol' => 'tcp',
      'dport'    => 443,
      'comment'  => 'HTTPS',
    },
    {
      'protocol' => 'tcp',
      'dport'    => 5222,
      'comment'  => 'JABBERD',
    },
  ],
  $locality,
  $organization,
  $organizational_unit,
  $private_ssl_key,
  $proxy_version,
  $rhn_channels,
  $sat_user,
  $sat_passwd,
  $state,
  $trusted_ssl_cert,
) {
  # AB: code here must have not side effects. Only setting
  # of variables is allowed!
  include stdlib
  include abutil

  # AB: validate class parameters.
  case $::puppetversion {
    /^3\.[6789].*/: {
      fail("Puppet version ${::puppetversion} not yet implemented.")
    } # puppet >= 3.6 and < 4.0

    /^3\.[012345].*/: {
      validate_string($cakey_passwd)
      if absize($cakey_passwd) == 0 {
        fail("\$${title}::cakey_passwd not set")
      }
      validate_string($country_code)
      if absize($country_code) != 2 {
        fail("\$${title}::country_code not set")
      }
      validate_array($iptables_lines)
      if absize($iptables_lines) == 0 {
        fail("\$${title}::iptables_lines not set")
      }
      validate_string($locality)
      if absize($locality) == 0 {
        fail("\$${title}::locality not set")
      }
      validate_string($organization)
      if absize($organization) == 0 {
        fail("\$${title}::organization not set")
      }
      validate_string($organizational_unit)
      if absize($organizational_unit) == 0 {
        fail("\$${title}::organizational_unit not set")
      }
      validate_string($private_ssl_key)
      if absize($private_ssl_key) == 0 {
        fail("\$${title}::private_ssl_key not set")
      }
      validate_string($proxy_version)
      if absize($proxy_version) == 0 {
        fail("\$${title}::proxy_version not set")
      }
      validate_array($rhn_channels)
      if absize($rhn_channels) == 0 {
        fail("\$${title}::rhn_channels not set")
      }
      $rhn_channels.each |$el|{
        validate_string($el)
        if absize($el) == 0 {
          fail("\$${title}::rhn_channels not set")
        }
      } # each
      validate_string($sat_user)
      if absize($sat_user) == 0 {
        fail("\$${title}::sat_user not set")
      }
      validate_string($sat_passwd)
      if absize($sat_passwd) == 0 {
        fail("\$${title}::sat_passwd not set")
      }
      validate_string($state)
      if absize($state) == 0 {
        fail("\$${title}::state not set")
      }
      validate_string($trusted_ssl_cert)
      if absize($trusted_ssl_cert) == 0 {
        fail("\$${title}::trusted_ssl_cert not set")
      }
    } # puppet >= 3.0 and < 3.6

    default: {
      fail("Puppet version ${::puppetversion} not supported.")
    } # unsupported puppet versions
  } # case

  case $::operatingsystem {
    'CentOS': {
      $proxy_packages = [
        'spacewalk-proxy-selinux',
        'spacewalk-proxy-installer',
      ]
    } # CentOS

    # AB: note info comes from Proxy Installation Guide from
    # docs.redhat.com. We question the correctness since we
    # miss the SELinux for Spacewalk proxy RPM.
    'RedHat': {
      $proxy_packages = [
        'spacewalk-proxy-installer',
      ]
    } # RedHat

    default: {
      fail("${::operatingsystem} not supported")
    }
  } # case
} # end prov::proxy::params
