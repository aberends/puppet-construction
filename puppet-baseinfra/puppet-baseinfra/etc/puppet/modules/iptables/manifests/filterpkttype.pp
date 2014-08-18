# == Class: iptables::filterpkttype
#
# This helper class creates a directory in which the
# iptables filter rules for pkttype filtering can be
# collected.
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
class iptables::filterpkttype inherits iptables::params {
  if $want_iptables == 'yes' {
    require iptables::install

    file {$iptables::install::filter_pkttype_dir:
      ensure  => directory,
    }

    file {"${iptables::install::filter_pkttype_dir}/${iptables::install::filter_postscript}":
      ensure  => present,
      source  => 'puppet:///modules/iptables/filter_postscript',
      require => File[$iptables::install::filter_pkttype_dir],
    }
  } else {
    notify {"${title}, \$want_iptables? no, skipped.":
      withpath => true,
    }
  } # $want_iptables
} # end iptables::filterpkttype
