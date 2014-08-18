# == Class: iptables
#
# This class configures and runs iptables.
#
# === Parameters
#
# All parameters used as an configuration interface are
# placed in the iptables::params class.
#
# === Variables
#
# === Examples
#
#  include iptables
#
# === Authors
#
# Allard Berends <allard.berends@example.com> (AB)
#
# === Copyright
#
# Copyright 2014 Allard Berends
#
class iptables inherits iptables::params {
  if $want_iptables == 'yes' {
    require iptables::install
    require iptables::filterdport
    require iptables::filterpkttype

    exec {'update_iptables_filterdport':
      command => "/bin/cat ${filter_dport_dir}/* > ${filter_dportconfig}",
      onlyif  => ["/usr/bin/test -d ${filter_dport_dir} -a ${filter_dport_dir} -nt ${filter_dportconfig}"],
    }

    exec {'update_iptables_filterpkttype':
      command => "/bin/cat ${filter_pkttype_dir}/* > ${filter_pkttypeconfig}",
      onlyif  => ["/usr/bin/test -d ${filter_pkttype_dir} -a ${filter_pkttype_dir} -nt ${filter_pkttypeconfig}"],
    }

    exec {'update_iptables_nat':
      command => "/bin/cat ${nat_dir}/* > ${nat_config}",
      onlyif  => ["/usr/bin/test -d ${nat_dir} -a ${nat_dir} -nt ${nat_config}"],
    }

    exec {'update_iptables':
      command => "/bin/cat ${filter_dportconfig} ${filter_pkttypeconfig} ${nat_config} > ${config} 2>/dev/null ; /bin/echo -n",
      onlyif  => "/usr/bin/test -f ${filter_dportconfig} -a ${filter_dportconfig} -nt ${config} -o ${filter_pkttypeconfig} -a ${filter_pkttypeconfig} -nt ${config} -o -f ${nat_config} -a ${nat_config} -nt ${config}",
      require => Exec[
        'update_iptables_filterdport',
        'update_iptables_filterpkttype',
        'update_iptables_nat'
      ],
    }

    service {'iptables':
      ensure    => 'running',
      enable    => true,
      subscribe => Exec['update_iptables'],
    }
  } else {
    notify {"${title}, \$want_iptables? no, skipped.":
      withpath => true,
    }
  } # $want_iptables
} # end iptables
