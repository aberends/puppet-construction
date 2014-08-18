class profiles::lvs::ldap {
  include stdlib

  # Parameter lookups
  $layer1   = loadyaml("/var/lib/hiera/depzones/${depzone}/hosts/${fqdn}.yaml")
  $instance = $layer1['lvs::ldap::instance']
  $platform = $layer1['lvs::ldap::platform']
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
  $h_lvs_ha = merge(
    $layer8,
    $layer7,
    $layer6,
    $layer5,
    $layer4,
    $layer3,
    $layer2,
    $layer1
  )

  # Initialize module parameters
  class{'::lvs::ldap::params':
    backup           => $h_lvs_ha['lvs::ldap::params::backup'],
    backup_private   => $h_lvs_ha['lvs::ldap::params::backup_private'],
    ldap_domain      => hiera('ldap::client::params::ldap_domain'),
    nmask            => $h_lvs_ha['lvs::ldap::params::nmask'],
    primary          => $h_lvs_ha['lvs::ldap::params::primary'],
    primary_private  => $h_lvs_ha['lvs::ldap::params::primary_private'],
    servers          => $h_lvs_ha['lvs::ldap::params::servers'],
    vip              => $h_lvs_ha['lvs::ldap::params::vip'],
    vmac             => $h_lvs_ha['lvs::ldap::params::vmac'],
  }
  ->
  class{'::lvs::ldap::server':}
}
