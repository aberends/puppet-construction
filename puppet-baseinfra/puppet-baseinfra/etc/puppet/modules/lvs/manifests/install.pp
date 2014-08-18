# == Class: lvs::install
#
# This helper class ensures that the lvs RPM's are
# installed.
#
# === Parameters
#
# All parameters used as an configuration interface are
# placed in the lvs::params class.
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
class lvs::install inherits lvs::params {

  case $::operatingsystem {
    'CentOS': { } # CentOS

    'RedHat': {
      require lvs::lb_channel
    } # RedHat

    default: { }
  } # case

  package{$lvs_packages:
    ensure  => 'installed',
  }
} # end lvs::install

