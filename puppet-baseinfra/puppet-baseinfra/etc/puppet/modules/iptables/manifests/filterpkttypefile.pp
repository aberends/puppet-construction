# == Define: filterpkttypefile
#
# This define places "--pkt-type p" iptables
# rules in the filter table of iptables.
#
# Be sure to include the "before   => Class['iptables']"
# statement. See example!
#
# === Parameters
#
# *comment*
#   Comment in the iptables rules set
# *pkttype*
#   Packet type to allow
# *protocol*
#   Protocol to use, e.g. tcp or udp
#
# === Variables
#
# None
#
# === Examples
#
#  iptables::filterpkttypefile {'multicast_wls::instance':
#    comment  => 'WLS multicast',
#    pkttype    => 'multicast',
#    before   => Class['iptables'],
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
define iptables::filterpkttypefile (
  $comment,
  $pkttype,
) {
  if $iptables::params::want_iptables == 'yes' {
    require iptables::filterpkttype
    file {$title:
      ensure  => file,
      content => sprintf("-A RH-Firewall-1-INPUT -m pkttype --pkt-type %s -m comment --comment \"%s\" -j ACCEPT\n", $pkttype, $comment)
    }
  } else {
    notify {"${title}, \$want_iptables? no, skipped.":
      withpath => true,
    }
  } # $want_iptables
} # end iptables::filterpkttypefile
