# == Define: filterdportfile
#
# This define places "--dport n" iptables rules in the
# filter table of iptables.
#
# Be sure to include the "before => Class['iptables']"
# statement. See example!
#
# === Dependencies
#
# iptables::filterdport
#
# === Parameters
#
# *comment*
#   Comment in the iptables rule. This is the value of the
#   --comment option.
# *dport*
#   Destination port to open. This is the value of the
#   --dport option.
# *protocol*
#   Protocol to use, e.g. tcp or udp. This is the value of
#   the -p option.
#
# === Variables
#
# === Examples
#
#  require iptables::filterdport
#  iptables::filterdportfile {"00123_tcp_ntpserver":
#    comment  => 'NTP',
#    dport    => 123,
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
define iptables::filterdportfile (
  $comment,
  $dport,
  $protocol,
) {
  if $iptables::params::want_iptables == 'yes' {
    require iptables::filterdport

    file {$title:
      ensure  => file,
      content => sprintf("-A RH-Firewall-1-INPUT -m %s -p %s -m state --state NEW --dport %s -m comment --comment \"%s\" -j ACCEPT\n", $protocol, $protocol, $dport, $comment)
    }
  } else {
    notify {"${title}, \$want_iptables? no, skipped.":
      withpath => true,
    }
  } # $want_iptables
} # end iptables::filterdportfile
