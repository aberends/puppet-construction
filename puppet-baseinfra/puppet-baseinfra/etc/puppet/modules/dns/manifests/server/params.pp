# == Class: dns::server::params
#
# This interface class provides the configuration interface
# of the dns server module. All other classes in the dns
# server module inherit these class parameters.
#
# The default values of the parameters can be overridden in
# YAML files. All the parameters are validated in this
# class.
#
# === Dependencies
#
# === Parameters
#
# *auto_zone*
#   Default: 'no'
#
#   If set to true, the zone files are automatically
#   generated from the node YAML files. The zone files for
#   the specified depzone are created. See depz parameter.
# *depz*
#   Default: '' (empty string)
#
#   If not specified and auto_zone is yes, then the facter
#   fact depzone is used. If specified and auto_zone is
#   yes, then the zone files for the specified depzone are
#   created.
# *iptables_lines*
#   Default: [
#     {
#       'protocol' => 'tcp',
#       'dport'    => 53,
#       'comment'  => 'DNS',
#     },
#     {
#       'protocol' => 'udp',
#       'dport'    => 53,
#       'comment'  => 'DNS',
#     },
#   ]
#
#   The TCP and UDP ports to be opened in the host's
#   firewall to support DNS.
# *tools_channel*
#   Default: [] (empty array)
#
#   Spacewalk channels with custom RPM's for Puppet and
#   supporting channels. For example:
#   ['example-puppet-tools-6u5-1_0',
#   'example-epel-6u5-1_0'].
#
# === Variables
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
class dns::server::params (
  $auto_zone           = 'no',
  $depz                = '',
  $iptables_lines      = [
    {
      'protocol' => 'tcp',
      'dport'    => 53,
      'comment'  => 'DNS',
    },
    {
      'protocol' => 'udp',
      'dport'    => 53,
      'comment'  => 'DNS',
    },
  ],
  $tools_channel       = [],
) {
  # AB: code here must have not side effects. Only setting
  # of variables is allowed!

  # AB: validate class parameters.
  case $::puppetversion {
    /^3\.[6789].*/: {
      fail("Puppet version ${::puppetversion} not yet implemented.")
    } # puppet >= 3.6 and < 4.0

    /^3\.[012345].*/: {
      validate_string($auto_zone)
      unless $auto_zone in ['yes', 'no'] {
        fail("\$${title}::auto_zone not set")
      }
      validate_string($depz)
      validate_array($iptables_lines)
      if size($iptables_lines) == 0 {
        fail("\$${title}::iptables_lines not set")
      }
      validate_array($tools_channel)
    } # puppet >= 3.0 and < 3.6

    default: {
      fail("Puppet version ${::puppetversion} not supported.")
    } # unsupported puppet versions
  } # case

  # AB: rng-tools is needed to speed up the initial creation
  # of rndc.key
  $srv_packages = [
    'bind-chroot',
    'rng-tools',
  ]
} # end dns::server::params
