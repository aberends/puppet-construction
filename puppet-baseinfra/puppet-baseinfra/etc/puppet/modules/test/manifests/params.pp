# == Class: test::params
#
# This interface class provides the configuration interface
# of the test module. All other classes in the test module
# inherit these class parameters.
#
# The default values of the parameters can be overridden in
# YAML files. All parameters are validated in this class.
#
# === Dependencies
#
# === Parameters
#
# :hierarchy:
#   - depzones/%{depzone}/hosts/%{fqdn}
#   - depzones/%{depzone}/platforms/%{platform}/%{instance}
#   - depzones/%{depzone}/platforms/%{platform}
#   - depzones/%{depzone}/%{subzone}
#   - depzones/%{depzone}
#   - platforms/%{platform}/%{instance}
#   - platforms/%{platform}
#   - base
#
# With:
#
# depzone  == dmsat1
# fqdn     == ds1.dmsat1.org
# platform == test
# instance == test1
# subzone  == dmz
#
# the file search order is:
#
# 1 depzones/dmsat1/hosts/ds1.dmsat1.org.yaml
# 2 depzones/dmsat1/platforms/test/test1.yaml
# 3 depzones/dmsat1/platforms/test.yaml
# 4 depzones/dmsat1/dmz.yaml
# 5 depzones/dmsat1.yaml
# 6 platforms/test/test1.yaml
# 7 platforms/test.yaml
# 8 base.yaml
#
# *par1*
#   To be found in level 1, ds1.dmsat1.org.yaml.
# *par2*
#   To be found in level 2, test1.yaml (under dmsat1).
# *par3*
#   To be found in level 3, test.yaml (under dmsat1).
# *par4*
#   To be found in level 4, dmz.yaml.
# *par5*
#   To be found in level 5, dmsat1.yaml.
# *par6*
#   To be found in level 6, test1.yaml.
# *par7*
#   To be found in level 7, test.yaml.
# *par8*
#   To be found in level 8, base.yaml.
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
class test::params (
  $par1,
  $par2,
  $par3,
  $par4,
  $par5,
  $par6,
  $par7,
  $par8,
) {
  # AB: code here must have not side effects. Only setting
  # of variables is allowed!

  # AB: validate class parameters.
  case $::puppetversion {
    /^3\.[6789].*/: {
      fail("Puppet version ${::puppetversion} not yet implemented.")
    } # puppet >= 3.6 and < 4.0

    /^3\.[012345].*/: {
      validate_string($par1)
      if size($par1) == 0 {
        fail("${title}::\$par1 not set")
      }
      validate_string($par2)
      if size($par2) == 0 {
        fail("${title}::\$par2 not set")
      }
      validate_string($par3)
      if size($par3) == 0 {
        fail("${title}::\$par3 not set")
      }
      validate_string($par4)
      if size($par4) == 0 {
        fail("${title}::\$par4 not set")
      }
      validate_string($par5)
      if size($par5) == 0 {
        fail("${title}::\$par5 not set")
      }
      validate_string($par6)
      if size($par6) == 0 {
        fail("${title}::\$par6 not set")
      }
      validate_string($par7)
      if size($par7) == 0 {
        fail("${title}::\$par7 not set")
      }
      validate_string($par8)
      if size($par8) == 0 {
        fail("${title}::\$par8 not set")
      }
    } # puppet >= 3.0 and < 3.6

    default: {
      fail("Puppet version ${::puppetversion} not supported.")
    } # unsupported puppet versions
  } # case
} # end test::params
