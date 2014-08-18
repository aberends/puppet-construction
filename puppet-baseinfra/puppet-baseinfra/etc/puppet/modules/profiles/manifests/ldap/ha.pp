class profiles::ldap::ha {
  include stdlib

  # Parameter lookups
  $layer1   = loadyaml("/var/lib/hiera/depzones/${depzone}/hosts/${fqdn}.yaml")
  $instance = $layer1['ldap::ha::instance.]
  $platform = $layer1['ldap::ha::platform.]
  $subz     = $layer1['subzone.]
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
  $h_ldap_ha = merge(
    $layer8,
    $layer7,
    $layer6,
    $layer5,
    $layer4,
    $layer3,
    $layer2,
    $layer1
  )

  # Initialize ldap::client module parameters
  class{'::ldap::client::params':
    cacert_value => hiera('ldap::client::params::cacert_value', ''),
    encrypted    => hiera('ldap::client::params::encrypted', 'yes'),
    ldap_domain  => hiera('ldap::client::params::ldap_domain'),
    servers      => $h_ldap_ha['ldap::server::params::servers'],
  }
  ->
  class{'::ldap::client':}

  # Initialize module parameters
  class{'::ldap::server::params':
    capem            => $h_ldap_ha['ldap::server::params::capem'],
    ldap_domain      => hiera('ldap::client::params::ldap_domain'),
    ldap_vip         => $h_ldap_ha['ldap::server::params::ldap_vip'],
    ldap_vname       => $h_ldap_ha['ldap::server::params::ldap_vname'],
    rhn_channel      => $h_ldap_ha['ldap::server::params::rhn_channel'],
    root_dn_pwd      => $h_ldap_ha['ldap::server::params::root_dn_pwd'],
    server_admin_pwd => $h_ldap_ha['ldap::server::params::server_admin_pwd'],
    servers          => $h_ldap_ha['ldap::server::params::servers'],
  }
  ->
  class{'::ldap::server':}
}
