# == Class: ntp::client::params
#
# This interface class provides the configuration interface
# of the ntp::client module. All other classes in the
# ntp::client module inherit these class parameters.
#
# The default values of the parameters can be overridden in
# YAML files. All the paremters are validated in this class.
#
# === Dependencies
#
# stdlib
#
# === Parameters
#
# *servers*
#   Default: None
#
#   Array with FQDN's of the stratum 2 servers of the NTP
#   system within our network. As ntp::client we connect to
#   these servers.
#
# === Variables
#
# *ntp_packages*
#   Array of RPM's to be installed.
# *ntp_packages6*
#   Array of extra RHEL6 RPM's to be installed.
# *ntp_services*
#   Array of NTP services that must be enabled and running.
# *ntp_services6*
#   Array of extra RHEL6 NTP services that must be enabled
#   and running.
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
class ntp::client::params (
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
      validate_array($servers)
      $servers.each |$el|{
        validate_string($el)
        unless is_domain_name($el) {
          fail("\$${title}::servers element \"${el}\"must be FQDN")
        }
      } # each
    } # puppet >= 3.0 and < 3.6

    default: {
      fail("Puppet version ${::puppetversion} not supported.")
    } # unsupported puppet versions
  } # case

  $ntp_packages = ['ntp']
  $ntp_services = ['ntpd']

  if $::operatingsystemmajrelease == '6' {
    $ntp_packages6 = ['ntpdate']
    $ntp_services6 = ['ntpdate']
  } # if
} # end ntp::client::params
