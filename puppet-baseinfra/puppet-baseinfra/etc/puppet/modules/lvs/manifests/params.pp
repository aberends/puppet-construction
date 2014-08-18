# == Class: lvs::params
#
# This interface class provides the configuration interface
# of the lvs base module. All other classes in the lvs base
# module inherit these class parameters.
#
# The default values of the parameters can be overridden in
# YAML files. All the parameters are validated in this
# class.
#
# === Dependencies
#
# In case of provisioning the LVS server, the functioning
# of the lvs module depends on configuration of the
# Spacewalk/Satellite server lb_channel for RHEL 6. For
# CentOS 6, the packages are in the base channel.
#
# === Parameters
#
# *lb_channel*
#   Default: '' (empty string)
#   Type:    'server'
#
#   Label of the Spacewalk/Satellite software channel in
#   which the RPM's for the LVS server are located. Note,
#   this paremeter is only relevant for provisioning of the
#   LVS server on RHEL 6. The default value is set to '' to
#   make sure that Puppet compilation works. This is a
#   workaround.
#
# === Variables
#
# *lvs_packages*
#   Packages needed for LVS.
# *services*
#   names of the services to be enabled and started.
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
class lvs::params (
  $lb_channel          = '',
) {
  # AB: code here must have not side effects. Only setting
  # of variables is allowed!

  # AB: validate class parameters.
  case $::puppetversion {
    /^3\.[6789].*/: {
      fail("Puppet version ${::puppetversion} not yet implemented.")
    } # puppet >= 3.6 and < 4.0

    /^3\.[012345].*/: {
      validate_string($lb_channel)
      if $::operatingsystem == 'RedHat' {
        if size($lb_channel) == 0 {
          fail("${title}::\$lb_channel not set")
        }
      } # RHEL 6
    } # puppet >= 3.0 and < 3.6

    default: {
      fail("Puppet version ${::puppetversion} not supported.")
    } # unsupported puppet versions
  } # case

  # AB: calculated variables
  $lvs_packages = ['piranha']
  $services     = ['pulse']
} # end lvs::params
