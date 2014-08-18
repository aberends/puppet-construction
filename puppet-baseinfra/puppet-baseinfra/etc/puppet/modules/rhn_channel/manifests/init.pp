# == Define: rhn_channel
#
# This define subscribes to an RHN software channel.
#
# === Parameters
#
# *user*
#   Satellite org account
# *password*
#   Satellite org account password
#
# === Variables
#
# === Examples
#
#  rhn_channel {'example-epel-6u5-1_0':
#    user     => 'example',
#    password => 'redhat',
#  }
#
# === Authors
#
# Allard Berends <allard.berends@example.com> (AB)
#
# === Copyright
#
# Copyright 2014 Allard Berends
#
define rhn_channel (
  $user     = hiera('rhn_channel::sat_user'),
  $password = hiera('rhn_channel::sat_passwd'),
) {
  exec {$title:
    command => "/usr/sbin/rhn-channel --channel ${title} --add --user ${user} --password ${password}",
    onlyif  => "/bin/bash -c \"[ -z $(/usr/sbin/rhn-channel --list | /bin/grep ${title}) ]\"",
  }
} # end rhn_channel
