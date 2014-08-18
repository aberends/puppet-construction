# == Class: dev::dev
#
# This construction class installs and configures the basic
# dev function.
#
# Supported OSses and versions:
# * CentOS
#   * 6
# * RHEL
#   * 6
#
# === Dependencies
#
# stdlib
#
# === Parameters
#
# All parameters used as an configuration interface are
# placed in the dev::dev::params class.
#
# === Variables
#
# === Examples
#
# === Authors
#
# Allard Berends <allard.berends@example.com> (AB)
#
# === Copyright
#
# Copyright 2014 Allard Berends
#
# === Bugs
#
class dev::dev inherits dev::dev::params {
  include stdlib

} # end dev::dev
