class roles::ldapntp::simple {
  include profiles::base6
  include profiles::ldap::simple
  include profiles::ntp::server
}
