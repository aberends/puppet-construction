# == Class: lvs::ldap::params
#
# This interface class provides the configuration interface
# of the lvs::ldap module. All other classes in the
# lvs::ldap module inherit these class parameters.
#
# The default values of the parameters can be overridden in
# YAML files. All the parameters are validated in this
# class.
#
# LVS nodes can be a primary LVS server or a backup LVS
# server. The backup node takes over the load-balancing when
# the primary node fails. The LVS function uses its own
# heartbeat mechanism to determine if an LVS node fails.
#
# In this module, we demand a setup of 2 LVS nodes.
#
# === Dependencies
#
# In case of provisioning the LVS server, the functioning
# of the lvs module depends on configuration of the
# Spacewalk/Satellite server lb_channel for RHEL 6. For
# CentOS 6, the packages are in the base channel.
#
# The functioning of the LVS for LDAP depends on the ldap
# client tools being installed. This can be done by
# including ldap::client.
#
# === Parameters
#
# *backup*
#   Default: None
#
#   The IPv4 address of the backup LVS node. This IPv4
#   address must be given in a YAML file.
# *backup_private*
#   Default: None
#
#   The IPv4 address on a separate LAN of the backup LVS
#   node. This address is used to check the heartbeat. If a
#   separate heartbeat LAN is used, this address must be
#   given in a YAML file. The private heartbeat LAN is
#   switched on by specifying an IPv4 address here.
# *check_dir*
#   Default: '/usr/local/bin'
#
#   Directory in which the real server checks scripts are
#   stored.
# *check_ds*
#   Default: 'check_ds.sh'
#
#   Name of the script that checks if the real servers are
#   up for answering ldap requests.
# *check_ds_ssl*
#   Default: 'check_ds_ssl.sh'
#
#   Name of the script that checks if the real servers are
#   up for answering ldap over ssl requests. Note, this
#   script is only used if encrypted is set to 'yes'.
# *encrypted*
#   Default: 'yes'
#
#   If encrypted is set to 'yes', an extra entry is created
#   in the lvs.cf file to enable LDAP over SSL.
# *iptables_lines*
#   Default: [
#     {
#       'protocol' => 'tcp',
#       'dport'    => 389,
#       'comment'  => 'LDAP',
#     },
#     {
#       'protocol' => 'tcp',
#       'dport'    => 539,
#       'comment'  => 'PULSE',
#     },
#     {
#       'protocol' => 'udp',
#       'dport'    => 539,
#       'comment'  => 'PULSE',
#     },
#     {
#       'protocol' => 'tcp',
#       'dport'    => 636,
#       'comment'  => 'LDAPS',
#     },
#     {
#       'protocol' => 'tcp',
#       'dport'    => 9830,
#       'comment'  => 'RHDS admin',
#     },
#   ]
#
#  The TCP ports to be opened in the host's firewall to
#  support LDAP, LDAP over SSL (LDAPS), strictly spoken TLS,
#  and the admin console. We have a little bug here: if
#  encrypted is set to 'no', then we still create the 636
#  port in iptables.
# *ldap_domain*
#   Default: None
#
#   The LDAP domain used by the LVS check scripts as a base
#   to start an ldapsearch. For example: dc=example,dc=com
# *lvs_cf*
#   Default: '/etc/sysconfig/ha/lvs.cf'
#
#   the LVS lvs.cf configution file.
# *nmask*
#   Default: None
#
#   The IPv4 network mask of the vip. For example,
#   255.255.255.0. It must be specified in a YAML file.
# *primary*
#   Default: None
#
#   The IPv4 address of the primary LVS node. This IPv4
#   address must be given in a YAML file.
# *primary_private*
#   Default: None
#
#   The IPv4 address on a separate LAN of the primary LVS
#   node. This address is used to check the heartbeat. If a
#   separate heartbeat LAN is used, this address must be
#   given in a YAML file. The private heartbeat LAN is
#   switched on by specifying an IPv4 address here.
# *servers*
#   Default: None
#
#   Array of IPv4 address of the real servers, i.e. the LDAP
#   servers.
# *vip*
#   Default: '' (empty string)
#
#   The LDAP service IPv4 (virtual IP). It must be specified
#   in a YAML file.
# *vmac*
#   Default: '' (empty string)
#
#   The virtual ethernet interface name on which the vip is
#   set. For example, em1:1 or bond0:1.
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
class lvs::ldap::params (
  $backup,
  $backup_private  = '',
  $check_dir       = '/usr/local/bin',
  $check_ds        = 'check_ds.sh',
  $check_ds_ssl    = 'check_ds_ssl.sh',
  $encrypted       = 'yes',
  $iptables_lines  = [
    {
      'protocol' => 'tcp',
      'dport'    => 389,
      'comment'  => 'LDAP',
    },
    {
      'protocol' => 'tcp',
      'dport'    => 539,
      'comment'  => 'PULSE',
    },
    {
      'protocol' => 'udp',
      'dport'    => 539,
      'comment'  => 'PULSE',
    },
    {
      'protocol' => 'tcp',
      'dport'    => 636,
      'comment'  => 'LDAPS',
    },
  ],
  $lvs_cf          = '/etc/sysconfig/ha/lvs.cf',
  $ldap_domain,
  $nmask,
  $primary,
  $primary_private = '',
  $servers,
  $vip,
  $vmac,
) {
  # AB: code here must have not side effects. Only setting
  # of variables is allowed!

  # AB: validate class parameters.
  case $::puppetversion {
    /^3\.[6789].*/: {
      fail("Puppet version ${::puppetversion} not yet implemented.")
    } # puppet >= 3.6 and < 4.0

    /^3\.[012345].*/: {
      unless is_ip_address($backup) {
        fail("${backup} must be a valid IPv4 address")
      }
      validate_string($backup_private)
      if size($backup_private) > 0 {
        unless is_ip_address($backup_private) {
          fail("${backup_private} must be a valid IPv4 address")
        }
      } # if
      validate_string($check_dir)
      if size($check_dir) == 0 {
        fail("${title}::\$check_dir not set")
      }
      validate_string($check_ds)
      if size($check_ds) == 0 {
        fail("${title}::\$check_ds not set")
      }
      validate_string($check_ds_ssl)
      if size($check_ds_ssl) == 0 {
        fail("${title}::\$check_ds_ssl not set")
      }
      unless $encrypted in ['yes', 'no'] {
        fail("${title}::\$encrypted not set")
      }
      validate_array($iptables_lines)
      if size($iptables_lines) == 0 {
        fail("${title}::\$iptables_lines not set")
      }
      validate_string($lvs_cf)
      if size($lvs_cf) == 0 {
        fail("${title}::\$lvs_cf not set")
      }
      validate_string($ldap_domain)
      if size($ldap_domain) == 0 {
        fail("${title}::\$ldap_domain not set")
      }
      unless is_ip_address($nmask) {
        fail("${nmask} must be a valid IPv4 netmask")
      }
      unless is_ip_address($primary) {
        fail("${primary} must be a valid IPv4 address")
      }
      validate_string($primary_private)
      if size($primary_private) > 0 {
        unless is_ip_address($primary_private) {
          fail("${primary_private} must be a valid IPv4 address")
        }
      } # if
      validate_array($servers)
      unless is_ip_address($servers[0]) {
        fail("${title}::\$servers' first element must be an IPv4")
      }
      unless is_ip_address($vip) {
        fail("${vip} must be a valid IPv4 address")
      }
      validate_string($vmac)
      if size($vmac) == 0 {
        fail("${title}::\$vmac not set")
      }
    } # puppet >= 3.0 and < 3.6

    default: {
      fail("Puppet version ${::puppetversion} not supported.")
    } # unsupported puppet versions
  } # case
} # end lvs::ldap::params
