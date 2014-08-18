class profiles::ldap::single {
  include stdlib

  # Parameter lookups
  $layer1   = loadyaml("/var/lib/hiera/depzones/${depzone}/hosts/${fqdn}.yaml")
  $instance = $layer1['ldap::single::instance']
  $platform = $layer1['ldap::single::platform']
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

  # AB: watch it here! Since we implement an LDAP server
  # instance on this node, the ldap::client module must use
  # the servers array from the ldap::server module.
  # Initialize ldap::client module parameters
  class{'::ldap::client::params':
    cacert_value => hiera('ldap::client::params::cacert_value'),
    encrypted    => hiera('ldap::client::params::encrypted', 'yes'),
    ldap_domain  => hiera('ldap::client::params::ldap_domain'),
    servers      => hiera('ldap::client::params::servers'),
  }
  ->
  class{'::ldap::client':}

  # Initialize ldap::server module parameters
  class{'::ldap::server::params':
    capem            => $h_ldap['ldap::server::params::capem'],
    ldap_domain      => hiera('ldap::client::params::ldap_domain'),
    mmr              => 'no',
    rhn_channel      => $h_ldap['ldap::server::params::rhn_channel'],
    root_dn_pwd      => $h_ldap['ldap::server::params::root_dn_pwd'],
    server_admin_pwd => $h_ldap['ldap::server::params::server_admin_pwd'],
    servers          => hiera('ldap::client::params::servers'),
    ssl              => 'yes',
  }
  ->
  class{'::ldap::server':}
}
