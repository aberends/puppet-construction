# == Class: test
#
# This construction class tests the puppet structure by
# notifying in which YAML level from /etc/hiera.yaml a
# parameter is set.
#
# === Parameters
#
# All parameters used as an configuration interface are
# placed in the test::params class.
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
class test inherits test::params {
  notify{"Value of \$par1 comes from ${par1}":}
  notify{"Value of \$par2 comes from ${par2}":}
  notify{"Value of \$par3 comes from ${par3}":}
  notify{"Value of \$par4 comes from ${par4}":}
  notify{"Value of \$par5 comes from ${par5}":}
  notify{"Value of \$par6 comes from ${par6}":}
  notify{"Value of \$par7 comes from ${par7}":}
  notify{"Value of \$par8 comes from ${par8}":}
} # end test
