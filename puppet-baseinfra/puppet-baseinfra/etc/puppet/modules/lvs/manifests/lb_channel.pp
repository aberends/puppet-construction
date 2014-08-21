# == Class: lvs::install
#
# This helper class ensures that the lvs software channel is
# subscribed to. This is only necessary for RHEL 6 systems.
# In CentOS 6, the RPM's are included in the base channel.
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
class lvs::lb_channel inherits lvs::params {
  rhn_channel{$lb_channel:}
} # end lvs::install

