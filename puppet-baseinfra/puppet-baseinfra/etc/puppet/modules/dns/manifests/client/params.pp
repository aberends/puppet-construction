# == Class: dns::client::params
#
# This interface class provides the configuration interface
# of the dns client module. All other classes in the dns
# client module inherit these class parameters.
#
# The default values of the parameters can be overridden in
# YAML files. All the paremters are validated in this class.
#
# === Dependencies
#
# === Parameters
#
# *domain*
#   Default: '' (empty string)
#
#   Local domain name. Don't specify it if it is the same as
#   the string after the first dot of the hostname. For
#   example, tgt1.rmt.dmsat1.org has a default local domain
#   of rmt.dmsat1.org. Mutually exclusive with search.
#   certificates.
# *search*
#   Default: '' (empty string)
#
#   Don't specify it if it is the same as the string after
#   the first dot of the hostname. For example,
#   tgt1.rmt.dmsat1.org has a default search domain of
#   rmt.dmsat1.org. Multipe search domains can be specified.
#   They must be space separated. Mutually exclusive with
#   domain.
# *servers*
#   Default: None
#
#   Array of IPv4 addresses, which are the DNS servers.
#
# === Variables
#
# === Examples
#
# === Authors
#
# Allard Berends <allard.berends@example.com> (AB)
#
# === History
#
# === Copyright
#
# Copyright 2014 Allard Berends
#
# === Bugs
#
class dns::client::params (
  $domain  = '',
  $search  = '',
  $servers,
) {
  include stdlib
  include abutil
  # AB: code here must have not side effects. Only setting
  # of variables is allowed!

  # AB: validate class parameters.
  case $::puppetversion {
    /^3\.[6789].*/: {
      fail("Puppet version ${::puppetversion} not yet implemented.")
    } # puppet >= 3.6 and < 4.0

    /^3\.[012345].*/: {
      validate_string($domain)
      validate_string($search)
      if size($domain) > 0 and size($search) > 0 {
          fail("\$${title}::domain and \$${title}::search are mutually exclusive")
      }
      if size($domain) > 0 {
        unless is_domain_name($domain) {
          fail("${title}::\$domain incorrect")
        }
      }
      # AB: $search can be space separated, so no simple
      # check is possible here.
      validate_array($servers)
      if size($servers) == 0 {
        fail("${title}::\$servers not set")
      }
      $servers.each |$el|{
        validate_string($el)
        unless is_ip_address($el) {
          fail("\$${title}::servers not set")
        }
      } # each
    } # puppet >= 3.0 and < 3.6

    default: {
      fail("Puppet version ${::puppetversion} not supported.")
    } # unsupported puppet versions
  } # case

} # end dns::client::params
