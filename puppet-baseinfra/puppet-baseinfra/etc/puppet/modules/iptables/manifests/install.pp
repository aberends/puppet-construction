# == Class: iptables::install
#
# This class is a helper class that ensures that the
# iptables package is installed.
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
# === Copyright
#
# Copyright 2014 Allard Berends
#
class iptables::install inherits iptables::params {
  if $want_iptables == 'yes' {
    package {'iptables':
      ensure  => 'installed',
    }

    file {$alias_file:
      ensure    => file,
      owner     => 'root',
      group     => 'root',
      mode      => '0644',
      source    => 'puppet:///modules/iptables/itl.sh',
    }
  } else {
    notify {"${title}, \$want_iptables? no, skipped.":
      withpath => true,
    }
  } # $want_iptables
} # end iptables::install
