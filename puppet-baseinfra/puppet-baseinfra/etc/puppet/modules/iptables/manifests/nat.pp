# == Class: iptables::nat
#
# This helper class creates a directory in which the
# iptables nat rules can be collected.
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
class iptables::nat inherits iptables::params {
  if $want_iptables == 'yes' {
    require iptables::install

    file {$iptables::install::nat_dir:
      ensure  => directory,
    }

    file {"${iptables::install::nat_dir}/${iptables::install::nat_preamble}":
      ensure  => present,
      source  => 'puppet:///modules/iptables/nat_preamble',
      require => File[$iptables::install::nat_dir],
    }

    file {"${iptables::install::nat_dir}/${iptables::install::nat_postscript}":
      ensure  => present,
      source  => 'puppet:///modules/iptables/nat_postscript',
      require => File[$iptables::install::nat_dir],
    }
  } else {
    notify {"${title}, \$want_iptables? no, skipped.":
      withpath => true,
    }
  } # $want_iptables
} # end iptables::nat
