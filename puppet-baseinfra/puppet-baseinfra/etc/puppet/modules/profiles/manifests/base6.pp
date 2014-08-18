class profiles::base6 {
  include stdlib

  # Initialize support6 module parameters
  class{'::support6::params':
    rpms => hiera('support6::params::rpms'),
  }
  ->
  class{'::support6':}

  $ldap_type = hiera('profiles::base6::ldap_type', '')
  unless $ldap_type == 'server' {
    # Initialize ldap::client module parameters
    class{'::ldap::client::params':
      cacert_value => hiera('ldap::client::params::cacert_value', ''),
      encrypted    => hiera('ldap::client::params::encrypted', 'yes'),
      ldap_domain  => hiera('ldap::client::params::ldap_domain'),
      servers      => hiera('ldap::client::params::servers'),
    }
    ->
    class{'::ldap::client':}
  } # not ldap server

  $ntp_type = hiera('profiles::base6::ntp_type', '')
  unless $ntp_type == 'server' {
    # Initialize ntp::client module parameters
    class{'::ntp::client::params':
      servers => hiera('ntp::client::params::servers'),
    }
    ->
    class{'::ntp::client':}
  } # not ntp server

}
