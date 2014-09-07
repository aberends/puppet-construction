# == Class: support6::params
#
# This interface class provides the configuration interface
# of the support6 module. All other classes in the support6
# module inherit these class parameters. This class makes
# generic parameters available to all other classes.
#
# The default values of the parameters can be overridden in
# YAML files. All the paremters are validated in this class.
#
# === Parameters
#
# *want_bashrc*
#   Default: 'no'
#
#   Get a development .bashrc on target node, under /root.
# *rpms*
#   Default: []
#
#   The array of RPM packages to install. The list must be
#   specified in a YAML file. Since it is functionally
#   allowed not to install any support6 RPM's, the list may
#   be empty. Hence the empty array as default.
#
# === Variables
#
# *blacklist*
#   List of RPM packages that may not be installed via this
#   module. The reason is that we know that theses packages
#   are installed via another module of the baseinfra. Note,
#   we have only placed RPM's in the blacklist that are
#   candidates. We did not put, e.g, httpd in this list. If
#   we would, we can put almost all RPM's in the list. So,
#   only put RPM's in the list that make sense as support
#   tools!
#
# === Authors
#
# Allard Berends <allard.berends@example.com> (AB)
#
# === Copyright
#
# Copyright 2014 Allard Berends
#
class support6::params (
  $rpms          = [],
  $want_bashrc   = 'no',
) {
  # AB: code here must have not side effects. Only setting
  # of variables is allowed!
  include stdlib

  # AB: assert CentOS 6 or RHEL 6.
  if "$::operatingsystemmajrelease" != '6' {
    fail("Module ${module_name} is only supported on CentOS 6 or RHEL 6")
  } # if

  # AB: in $blacklist, after the package name it is stated
  # in the comment in which module of baseinfra, the package
  # is already included. Note, that normally we would put
  # interface variables after interface parameters. In this
  # case $blacklist is used to verify the $rpms interface
  # parameter. Hence, it must be pulled here.
  $blacklist = [
    'openldap-clients', # ldap::client::params
    'nss-pam-ldapd',    # ldap::client::params
    'nscd',             # ldap::client::params
    'ntp'               # ntp::client::params
  ] # blacklist

  # AB: validate class parameters.
  case $::puppetversion {
    /^3\.[6789].*/: {
      fail("Puppet version ${::puppetversion} not yet implemented.")
    } # puppet >= 3.6 and < 4.0

    /^3\.[012345].*/: {
      validate_array($rpms)
      $rpms.each |$el|{
        validate_string($el)
        if size($el) == 0 {
          fail("${title}::\$rpms contains empty element")
        }
        if member($blacklist, $el) {
          fail("Failed, $el is in blacklist")
        } # in blacklist
      } # each
    } # puppet >= 3.0 and < 3.6

    default: {
      fail("Puppet version ${::puppetversion} not supported.")
    } # unsupported puppet versions
  } # case
} # end support6::params
