# == Class: ntp::clock::params
#
# This interface class provides the configuration interface
# of the ntp::clock module. All other classes in the
# ntp::clock module inherit these class parameters.
#
# The default values of the parameters can be overridden in
# YAML files. All the paremters are validated in this class.
#
# === Dependencies
#
# Puppet module iptables
#
# === Parameters
#
# *iptables_lines*
#   Default: [
#     {
#       'protocol' => 'tcp',
#       'dport'    => 123,
#       'comment'  => 'NTP',
#     },
#     {
#       'protocol' => 'udp',
#       'dport'    => 123,
#       'comment'  => 'NTP',
#     },
#   ]
#
#   The TCP/UDP ports to be opened in the host's firewall to
#   support NTP.
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
class ntp::clock::params (
  $iptables_lines = [
    {
      'protocol' => 'tcp',
      'dport'    => 123,
      'comment'  => 'NTP',
    },
    {
      'protocol' => 'udp',
      'dport'    => 123,
      'comment'  => 'NTP',
    },
  ],
) {
  # AB: code here must have not side effects. Only setting
  # of variables is allowed!

  # AB: validate class parameters.
  case $::puppetversion {
    /^3\.[6789].*/: {
      fail("Puppet version ${::puppetversion} not yet implemented.")
    } # puppet >= 3.6 and < 4.0

    /^3\.[012345].*/: {
      validate_array($iptables_lines)
      if size($iptables_lines) == 0 {
        fail("${title}::\$iptables_lines not set")
      }
    } # puppet >= 3.0 and < 3.6

    default: {
      fail("Puppet version ${::puppetversion} not supported.")
    } # unsupported puppet versions
  } # case

  $ntp_packages = ['ntp']
  $ntp_services = ['ntpd']
} # end ntp::clock::params
