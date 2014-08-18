class profiles::prov::proxy {
  include stdlib

  # Parameter lookups
  $layer1   = loadyaml("/var/lib/hiera/depzones/${depzone}/hosts/${fqdn}.yaml")
  $instance = $layer1['prov::proxy::instance']
  $platform = $layer1['prov::proxy::platform']
  $subz     = $layer1['subzone']
  if $instance {
    $layer2 = loadyaml("/var/lib/hiera/depzones/${depzone}/platforms/${platform}/${instance}.yaml")
  } else {
    $layer2 = {}
  }
  if $platform {
    $layer3 = loadyaml("/var/lib/hiera/depzones/${depzone}/platforms/${platform}.yaml")
  } else {
    $layer3 = {}
  }
  if $subz {
    $layer4 = loadyaml("/var/lib/hiera/depzones/${depzone}/subzones/${subz}.yaml")
  } else {
    $layer4 = {}
  }
  $layer5   = loadyaml("/var/lib/hiera/depzones/${depzone}.yaml")
  $layer6   = loadyaml("/var/lib/hiera/platforms/${platform}/${instance}.yaml")
  $layer7   = loadyaml("/var/lib/hiera/platforms/${platform}.yaml")
  $layer8   = loadyaml('/var/lib/hiera/base.yaml')

  # Parameter hash
  $h_ldap = merge(
    $layer8,
    $layer7,
    $layer6,
    $layer5,
    $layer4,
    $layer3,
    $layer2,
    $layer1
  )

  # Initialize prov::proxy module parameters
  class{'::prov::proxy::params':
    cakey_passwd        => $h_ldap['prov::proxy::params::cakey_passwd'],
    country_code        => $h_ldap['prov::proxy::params::country_code'],
    locality            => $h_ldap['prov::proxy::params::locality'],
    organization        => $h_ldap['prov::proxy::params::organization'],
    organizational_unit => $h_ldap['prov::proxy::params::organizational_unit'],
    private_ssl_key     => $h_ldap['prov::proxy::params::private_ssl_key'],
    proxy_version       => $h_ldap['prov::proxy::params::proxy_version'],
    rhn_channels        => $h_ldap['prov::proxy::params::rhn_channels'],
    sat_user            => hiera('rhn_channel::sat_user'),
    sat_passwd          => hiera('rhn_channel::sat_passwd'),
    state               => $h_ldap['prov::proxy::params::state'],
    trusted_ssl_cert    => $h_ldap['prov::proxy::params::trusted_ssl_cert'],
  }
  ->
  class{'::prov::proxy':}
}
