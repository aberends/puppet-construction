class profiles::ntp::server {
  include stdlib

  # Parameter lookups
  $layer1   = loadyaml("/var/lib/hiera/depzones/${depzone}/hosts/${fqdn}.yaml")
  $instance = $layer1['ntp::server::instance']
  $platform = $layer1['ntp::server::platform']
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

  # AB: watch it here! Since we implement an NTP server
  # instance on this node, the ntp::client module must not
  # be used.
  # Initialize ntp::server module parameters
  class{'::ntp::server::params':
    clocks  => $h_ntp_server['ntp::server::params::clocks'],
    servers => $h_ntp_server['ntp::server::params::servers'],
  }
  ->
  class{'::ntp::server':}
}
