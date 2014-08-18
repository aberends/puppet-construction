# == Class: iptables::filterdport
#
# This helper class creates a directory in which the
# iptables filter rules for destination port filtering can
# be collected.
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
class iptables::filterdport inherits iptables::params {
  if $want_iptables == 'yes' {
    require iptables::install

    file {$iptables::install::filter_dport_dir:
      ensure  => directory,
    }

    file {"${iptables::install::filter_dport_dir}/${iptables::install::filter_preamble}":
      ensure  => present,
      source  => 'puppet:///modules/iptables/filter_preamble',
      require => File[$iptables::install::filter_dport_dir],
    }
  } else {
    notify {"${title}, \$want_iptables? no, skipped.":
      withpath => true,
    }
  } # $want_iptables
} # end iptables::filterdport
