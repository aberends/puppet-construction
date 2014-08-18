# == Class: ntp::server::params
#
# This interface class provides the configuration interface
# of the ntp::server module. All other classes in the
# ntp::server module inherit these class parameters.
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
# *clocks*
#   Default: [] (empty array)
#
#   Array with FQDN's of the stratum 1 clocks of the NTP
#   system within our network. The statum 1 clocks are
#   devices that connect via Satellites or radio to the
#   reference time, or Universally Coordinated Time (UTC),
#   wich is the time calculated by 300 atomic clocks. The
#   reference time is sometimes called stratum 0.
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
# *servers*
#   Default: None
#
#   Array with FQDN's of the stratum 2 clocks of the NTP
#   system within our network. The array elements are
#   regarded as NTP peers.
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
class ntp::server::params (
  $clocks         = [],
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
  $servers        = [],
) {
  # AB: code here must have not side effects. Only setting
  # of variables is allowed!

  # AB: validate class parameters.
  case $::puppetversion {
    /^3\.[6789].*/: {
      fail("Puppet version ${::puppetversion} not yet implemented.")
    } # puppet >= 3.6 and < 4.0

    /^3\.[012345].*/: {
      validate_array($clocks)
      $clocks.each |$el|{
        validate_string($el)
        unless is_domain_name($el) {
          fail("\$${title}::clocks element \"${el}\"must be FQDN")
        }
      } # each
      validate_array($iptables_lines)
      if size($iptables_lines) == 0 {
        fail("${title}::\$iptables_lines not set")
      }
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
} # end ntp::server::params
