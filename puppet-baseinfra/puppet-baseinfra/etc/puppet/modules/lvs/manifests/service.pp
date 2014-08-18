# == Class: lvs::service
#
# This helper class ensures that the lvs services are
# enabled and running.
#
# === Parameters
#
# All parameters used as an configuration interface are
# placed in the lvs::params class.
#
# === Variables
#
#
# === Authors
#
# Allard Berends <allard.berends@example.com> (AB)
#
# === Copyright
#
# Copyright 2014 Allard Berends
#
class lvs::service inherits lvs::params {
  service{$services:
    ensure  => 'running',
    enable  => true,
  }
} # end lvs::service

