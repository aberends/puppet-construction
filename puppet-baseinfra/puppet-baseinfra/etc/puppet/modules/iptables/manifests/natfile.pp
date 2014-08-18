# == Define: natfile
#
# This define places "--dport n" iptables redirect rules in
# the nat table of iptables.
#
# Be sure to include the "before   => Class['iptables']"
# statement.
#
# === Parameters
#
# *chain*
#   Chain to use, e.g. PREROUTING, POSTROUTING
# *comment*
#   Comment in the iptables rules set
# *dip*
#   Destination IP address to match
# *dport*
#   Destination port to open
# *protocol*
#   Protocol to use, e.g. tcp or udp
#
# === Variables
#
# None
#
# === Examples
#
#  iptables::natfile {'00389_tcp_ldapserver':
#    chain    => 'PREROUTING',
#    comment  => 'LDAP',
#    dip      => '192.168.130.56',
#    dport    => 389,
#    protocol => 'tcp',
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
define iptables::natfile (
  $chain,
  $comment,
  $dip,
  $dport,
  $protocol,
) {
  if $iptables::params::want_iptables == 'yes' {
    require iptables::nat

    file {$title:
      ensure  => file,
      content => sprintf("-A %s -d %s -m %s -p %s --dport %d -m comment --comment \"%s\" -j REDIRECT\n", $chain, $dip, $protocol, $protocol, $dport, $comment)
    }
  } else {
    notify {"${title}, \$want_iptables? no, skipped.":
      withpath => true,
    }
  } # $want_iptables
} # end iptables::natfile
