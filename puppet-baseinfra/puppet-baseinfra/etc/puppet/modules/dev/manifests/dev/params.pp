# == Class: dev::dev::params
#
# This interface class provides the configuration interface
# of the dev dev module. All other classes in the dev dev
# module inherit these class parameters.
#
# The default values of the parameters can be overridden in
# YAML files. All the paremters are validated in this class.
#
# === Dependencies
#
# === Parameters
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
class dev::dev::params {
  include stdlib
  # AB: code here must have not side effects. Only setting
  # of variables is allowed!

  # AB: validate class parameters.
  case $::puppetversion {
    /^3\.[6789].*/: {
      fail("Puppet version ${::puppetversion} not yet implemented.")
    } # puppet >= 3.6 and < 4.0

    /^3\.[012345].*/: {
    } # puppet >= 3.0 and < 3.6

    default: {
      fail("Puppet version ${::puppetversion} not supported.")
    } # unsupported puppet versions
  } # case

} # end dev::dev::params
