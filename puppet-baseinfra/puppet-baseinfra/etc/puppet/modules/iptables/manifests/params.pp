# == Class: iptables::params
#
# This interface class provides the configuration interface
# of the iptables module. All other classes in the iptables
# module inherit these class parameters. This class makes
# generic parameters available to all other classes.
#
# The default values of the parameters can be overridden in
# YAML files. All the paremters are validated in this class.
#
# For testing purposes, one can disable the provisioning of
# the iptables function on module level, by setting
# want_iptables: 'no' in a YAML file.
#
# === Dependencies
#
# === Parameters
#
# *alias_file*
#   Default: /etc/profile.d/itl.sh
#
#   The alias file must be a path that is sourced when a
#   user logs in. It contains some iptables command
#   shortcuts.
# *config*
#   Default: /etc/sysconfig/iptables
#
#   The file via which the iptables firewall is configured.
# *filter_dportconfig*
#   Default: /root/iptables.dportfilter
#
#   The file in which the filter rules are pasted from the
#   $filter_dport_dir.
# *filter_dport_dir*
#   Default: /root/iptables.filterdport.d
#
#   The directory in which all the filter dport rules are
#   collected.
# *filter_pkttypeconfig*
#   Default: /root/iptables.pkttypefilter
#
#   The file in which the filter rules are pasted from the
#   $filter_pkttype_dir.
# *filter_pkttype_dir*
#   Default: /root/iptables.filterpkttype.d
#
#   The directory in which all the filter pkttype rules are
#   collected.
# *filter_postscript*
#   Default: zzzzz_iptables_filter
#
#   The file containing the footer of the filter section of
#   the iptables configuration. It must be the last file in
#   the $filter_pkttype_dir, ordered in an alphanumeric way.
# *filter_preamble*
#   Default: 00000_iptables_filter
#
#   The file containing the header of the filter section of
#   the iptables configuration. It must be the first file in
#   $filter_dport_dir, ordered in an alphanumeric way.
# *nat_config*
#   Default: /root/iptables.nat
#
#   The file in which the nat rules are pasted from the
#   $nat_dir.
# *nat_dir*
#   Default: /root/iptables.nat.d
#
#   The directory in which all the nat rules are collected.
# *nat_postscript*
#   Default: 65536_iptables_nat
#
#   The file containing the footer of the nat section of the
#   iptables configuration. It must be the last file in the
#   $nat_dir, ordered in an alphanumeric way.
# *nat_preamble*
#   Default: 00000_iptables_nat
#
#   The file containing the header of the nat section of the
#   iptables configuration. It must be the first file in
#   $nat_dir, ordered in an alphanumeric way.
# *want_iptables*
#   Default: yes
#
#   Configuration option to switch off the iptables
#   function. This parameter is handy, if one wants to test
#   a target node withoud the iptables installed.
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
class iptables::params (
  $alias_file           = '/etc/profile.d/itl.sh',
  $config               = '/etc/sysconfig/iptables',
  $filter_dportconfig   = '/root/iptables.dportfilter',
  $filter_dport_dir     = '/root/iptables.filterdport.d',
  $filter_pkttypeconfig = '/root/iptables.pkttypefilter',
  $filter_pkttype_dir   = '/root/iptables.filterpkttype.d',
  $filter_postscript    = 'zzzzz_iptables_filter',
  $filter_preamble      = '00000_iptables_filter',
  $nat_config           = '/root/iptables.nat',
  $nat_dir              = '/root/iptables.nat.d',
  $nat_postscript       = '65536_iptables_nat',
  $nat_preamble         = '00000_iptables_nat',
  $want_iptables        = 'yes',
) {
  # AB: code here must have not side effects. Only setting
  # of variables is allowed!

  # AB: validate class parameters.
  case $::puppetversion {
    /^3\.[6789].*/: {
      fail("Puppet version ${::puppetversion} not yet implemented.")
    } # puppet >= 3.6 and < 4.0

    /^3\.[012345].*/: {
      validate_string($alias_file)
      if size($alias_file) == 0 {
        fail("${title}::\$alias_file not set")
      }
      validate_string($config)
      if size($config) == 0 {
        fail("${title}::\$config not set")
      }
      validate_string($filter_dportconfig)
      if size($filter_dportconfig) == 0 {
        fail("${title}::\$filter_dportconfig not set")
      }
      validate_string($filter_dport_dir)
      if size($filter_dport_dir) == 0 {
        fail("${title}::\$filter_dport_dir not set")
      }
      validate_string($filter_pkttypeconfig)
      if size($filter_pkttypeconfig) == 0 {
        fail("${title}::\$filter_pkttypeconfig not set")
      }
      validate_string($filter_pkttype_dir)
      if size($filter_pkttype_dir) == 0 {
        fail("${title}::\$filter_pkttype_dir not set")
      }
      validate_string($filter_postscript)
      if size($filter_postscript) == 0 {
        fail("${title}::\$filter_postscript not set")
      }
      validate_string($filter_preamble)
      if size($filter_preamble) == 0 {
        fail("${title}::\$filter_preamble not set")
      }
      validate_string($nat_config)
      if size($nat_config) == 0 {
        fail("${title}::\$nat_config not set")
      }
      validate_string($nat_dir)
      if size($nat_dir) == 0 {
        fail("${title}::\$nat_dir not set")
      }
      validate_string($nat_postscript)
      if size($nat_postscript) == 0 {
        fail("${title}::\$nat_postscript not set")
      }
      validate_string($nat_preamble)
      if size($nat_preamble) == 0 {
        fail("${title}::\$nat_preamble not set")
      }
      validate_string($want_iptables)
      unless $want_iptables in ['yes', 'no'] {
        fail("${title}::\$want_iptables must be yes or no")
      }
    } # puppet >= 3.0 and < 3.6

    default: {
      fail("Puppet version ${::puppetversion} not supported.")
    } # unsupported puppet versions
  } # case
} # end iptables::params
