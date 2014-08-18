# == Class: dev::rpm::params
#
# This interface class provides the configuration interface
# of the dev rpm module. All other classes in the dev rpm
# module inherit these class parameters.
#
# The default values of the parameters can be overridden in
# YAML files. All the paremters are validated in this class.
#
# === Dependencies
#
# === Parameters
#
# *gpg_sign_key*
#   Default: None
#
#   Base64 encoded value of the GPG private key to sign
#   RPM's.
# *rpm_group*
#   Default: 'rpm'
#
#   Group to which the rpm account belongs.
# *rpm_gid*
#   Default: 1060
#
#   GID of the $rpm_group account
# *rpm_user*
#   Default: 'rpm'
#
#   User of the rpm account.
# *rpm_uid*
#   Default: 1060
#
#   UID of the $rpm_user account
#
# === Variables
#
# *rpm_home*
#   Home directory of the rpm account.
#
# === Examples
#
# *rpm_packages*
#   RPM's needed for RPM development.
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
class dev::rpm::params (
  $gpg_sign_key,
  $rpm_group    = 'rpm',
  $rpm_gid      = 1060,
  $rpm_user     = 'rpm',
  $rpm_uid      = 1060,
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
      validate_string($gpg_sign_key)
      unless size($gpg_sign_key) > 0 {
        fail("\$${title}::gpg_sign_key not set")
      }
      validate_string($rpm_group)
      unless size($rpm_group) > 0 {
        fail("\$${title}::rpm_group not set")
      }
      unless is_integer($rpm_gid) {
        fail("\$${title}::rpm_gid not set")
      }
      validate_string($rpm_user)
      unless size($rpm_user) > 0 {
        fail("\$${title}::rpm_user not set")
      }
      unless is_integer($rpm_uid) {
        fail("\$${title}::rpm_uid not set")
      }
    } # puppet >= 3.0 and < 3.6

    default: {
      fail("Puppet version ${::puppetversion} not supported.")
    } # unsupported puppet versions
  } # case

  # AB: calculated variables
  $rpm_home     = "/home/${rpm_user}"
  $rpm_key_file = "/home/${rpm_user}/.gpgkey"
  $rpm_macros   = "/home/${rpm_user}/.rpmmacros"

  case $::operatingsystemmajrelease {
    '6': {
      $rpm_packages = ['rpm-build', 'rpmlint']
    }

    default: {
      fail("Module ${module_name} is not supported on RHEL ${::operatingsystemmajrelease}")
    }
  }
} # end dev::rpm::params
