class profiles::dns::server {
  include stdlib

  # Parameter lookups
  $layer1   = loadyaml("/var/lib/hiera/depzones/${depzone}/hosts/${fqdn}.yaml")
  $instance = $layer1['dns::server::instance']
  $platform = $layer1['dns::server::platform']
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
  $h_ntp_server = merge(
    $layer8,
    $layer7,
    $layer6,
    $layer5,
    $layer4,
    $layer3,
    $layer2,
    $layer1
  )

  # Initialize dns::server module parameters
  if $h_ntp_server['dns::server::params::auto_zone'] == 'yes' {
    class{'::dns::server::params':
      auto_zone     => 'yes',
      depz          => '',
      tools_channel => $h_ntp_server['dns::server::params::tools_channel'],
    }
    ->
    class{'::dns::server':}
  } else {
    class{'::dns::server::params':
      auto_zone     => 'no',
      depz          => '',
      tools_channel => '',
    }
    ->
    class{'::dns::server':}
  }
}
