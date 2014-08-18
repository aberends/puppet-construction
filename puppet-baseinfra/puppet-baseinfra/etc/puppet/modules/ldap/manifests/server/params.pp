# == Class: ldap::server::params
#
# This interface class provides the configuration interface
# of the ldap server module. All other classes in the ldap
# server module inherit these class parameters.
#
# The default values of the parameters can be overridden in
# YAML files. All the parameters are validated in this
# class.
#
# === Dependencies
#
# The functioning of the ldap server module depends on
# configuration of the Spacewalk/Satellite server software
# channels. See the rhn_channel parameter.
#
# === Parameters
#
# *capem*
#   Default: None
#
#   The base64 encoded value of the X.509v3 certificate and
#   private key of the CA in this depzone. This parameter
#   must be provided from a YAML file. It has no default
#   value.
# *idle_timeout*
#   Default: 900
#
#   Timeout after which the LDAP server disconnects the TCP
#   connection.
# *iptables_lines*
#   Default: [
#     {
#       'protocol' => 'tcp',
#       'dport'    => 389,
#       'comment'  => 'LDAP',
#     },
#     {
#       'protocol' => 'tcp',
#       'dport'    => 636,
#       'comment'  => 'LDAPS',
#     },
#     {
#       'protocol' => 'tcp',
#       'dport'    => 9830,
#       'comment'  => 'RHDS admin',
#     },
#   ]
#
#  The TCP ports to be opened in the host's firewall to
#  support LDAP, LDAP over SSL (LDAPS), strictly spoken TLS,
#  and the admin console.
# *ldap_domain*
#   Default: None
#
#   The LDAP domain used by the clients and server. In the
#   sever, the backend database uses the LDAP domain as a
#   suffix. For example: dc=example,dc=com
# *ldap_vip*
#   Default: '' (empty string)
#
#   The LDAP service IP (virtual IP). Only used in
#   conjunction with ldap_vname.
# *ldap_vname*
#   Default: '' (empty string)
#
#   The LDAP service name (virtual name). This name can be
#   different from the actual hostname of the LDAP service.
#   In a setup where LVS loadbalancers are in front of mmr
#   LDAP servers, the vname is used.
# *mmr*
#   Default: 'yes'
#
#   If set to 'yes', multimaster replication switch on
#   scripts are created. This script must be run when both
#   LDAP servers are running. On either one, the mmr switch
#   on script can be run.
# *rhn_channel*
#   Default: '' (empty string)
#
#   Label of the Spacewalk/Satellite software channel in
#   which the RPM's for the LDAP server are located. Note,
#   this paremeter is only relevant for provisioning of the
#   LDAP server. The default value is set to '' to make sure
#   that Puppet compilation works. This is a workaround.
# *root_dn*
#   Default: 'cn=Directory Manager'
#
#   The root Distinguished Name of the LDAP server. This is
#   the LDAP equivalent of the Linux root account.
# *root_dn_pwd*
#   Default: '' (empty string)
#
#   The password belonging the the root DN. It must
#   typically be set in the host's YAML file.
# *server_admin*
#   Default: 'admin'
#
#   The administration account for the LDAP console. The
#   LDAP console is a GUI to configure the LDAP server.
# *server_admin_pwd*
#   Default: '' (empty string)
#
#   The password belonging the the LDAP console
#   administration account. It must typically be set in the
#   host's YAML file.
# *ssl*
#   Default: 'yes'
#
# *start_replication*
#   Default: '/root/start-replication.sh'
#
#   The generated script that must be run on either of the
#   2 LDAP servers to start multimaster replication.
#
# === Variables
#
# *cap12_file*
#   File ca.p12 in $slapd_path.
#   File containing the CA keypair in PKCS#12 format.
# *capem_file*
#   File ca.pem in $slapd_path.
#   File containing the CA keypair in PEM (Privacy Enhanced
#   Mail) format.
# *capem_run*
#   File ca.run in $slapd_path.
#   This is an artifact needed for Puppet to store state of
#   an exec resource type.
# *client_packages*
#   Packages needed for LDAP clients. Its value depends on
#   the OS major version.
# *idle_timeout_ldif*
#   File idle_timeout.ldif in $slapd_path.
#   This file contains the LDIF formatted entry via which
#   the idle_timeout parameter of LDAP server is set.
# *idle_timeout_run*
#   File idle_timeout.run in $slapd_path.
#   This is an artifact needed for Puppet to store state of
#   an exec resource type.
# *iptables_nat*
#   If the ldap_vname entry is set, the ldap_vip entry is
#   use in direct routing setup via the PREROUTING chain in
#   the iptables' nat table.
# *mmr_ldif_run*
#   File modify_mmr.run in $slapd_path.
#   This is an artifact needed for Puppet to store state of
#   an exec resource type.
# *mmr_ldif*
#   File modify_mmr.ldif in $slapd_path.
#   This file contains the LDIF formatted entries with which
#   the SSL function of LDAP server is switched on.
# *nss_noise*
#   File noise.txt in $slapd_path.
#   This files contains some randomness to speed up
#   generation of cryptographic elements for the server
#   keypair.
# *root_dn_pwd_file*
#   File pwdfile in $slapd_path.
#   File containing the password of the root DN.
# *server_cn*
#   The common name (cn) of the server in the server's
#   certificate, if ssl is used. It is either the FQDN of
#   this host, or, if ldap_vname is set, the ldap_vname.
# *services*
#   List of the service names to run the LDAP function.
#   Note, this makes the module possibly dependend on the
#   LDAP version and RHEL version. Not to speak on the LDAP
#   implementation. OpenLDAP cannot be provisioned by this
#   module.
# *srv_keypair_run*
#   File srv.run in $slapd_path.
#   This is an artifact needed for Puppet to store state of
#   an exec resource type.
# *ssl_ldif_run*
#   File modify_ssl.run in $slapd_path.
#   This is an artifact needed for Puppet to store state of
#   an exec resource type.
# *ssl_ldif*
#   File modify_ssl.ldif in $slapd_path.
#   This file contains the LDIF formatted entries with which
#   the SSL function of LDAP server is switched on.
# *ssl_pin*
#   File pin.txt in $slapd_path.
#   This file contains the pin code, needed for the slapd
#   process to unlock the security database file in
#   $slapd-path (cert8.db, key3.db, secmod.db)
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
# We use the parameters server_admin and server_admin_pwd
# for both the ConfigDirectoryAdminID, ServerAdminID and
# ConfigDirectoryAdminPwd, ServerAdminPwd. So, it is either
# misnamed or we should have different parameter sets for
# both accounts.
#
# The server port, 389, parameter is not parameterized,
# although we give the suggestion by allowing the filter and
# nat rules to be changed. The same reasoning goes for the
# SSL port 636 and the admin port 9830.
#
# The naming of this module is wrong. It suggests that we
# are general, but we are not. We implement the 389
# Directory Server project, which is the upstream project of
# the RHDS (Red Hat Directory Server), and the RHDS.
class ldap::server::params (
  $capem               = '',
  $idle_timeout        = 900,
  $iptables_lines      = [
    {
      'protocol' => 'tcp',
      'dport'    => 389,
      'comment'  => 'LDAP',
    },
    {
      'protocol' => 'tcp',
      'dport'    => 636,
      'comment'  => 'LDAPS',
    },
    {
      'protocol' => 'tcp',
      'dport'    => 9830,
      'comment'  => 'RHDS admin',
    },
  ],
  $ldap_domain,
  $ldap_vip            = '',
  $ldap_vname          = '',
  $ldaps_script        = '/root/ldaps.sh',
  $limits              = '/etc/security/limits.d/90-nofile.conf',
  $mmr                 = 'yes',
  $rhn_channel         = '',
  $root_dn             = 'cn=Directory Manager',
  $root_dn_pwd         = '',
  $server_admin        = 'admin',
  $server_admin_pwd    = '',
  $servers,
  $setup_inf           = '/root/setup.inf',
  $slapd_path          = '/etc/dirsrv/slapd-ds',
  $ssl                 = 'yes',
  $start_replication   = '/root/start-replication.sh',
) {
  # AB: code here must have not side effects. Only setting
  # of variables is allowed!

  # AB: validate class parameters.
  case $::puppetversion {
    /^3\.[6789].*/: {
      fail("Puppet version ${::puppetversion} not yet implemented.")
    } # puppet >= 3.6 and < 4.0

    /^3\.[012345].*/: {
      validate_string($ldap_domain)
      if size($ldap_domain) == 0 {
        fail("${title}::\$ldap_domain not set")
      }
      validate_array($servers)
      if size($servers) == 0 {
        fail("${title}::\$servers not set")
      }
      unless is_domain_name($servers[0]) {
        fail("${title}::\$servers first element not set")
      }
      validate_array($iptables_lines)
      if size($iptables_lines) == 0 {
        fail("${title}::\$iptables_lines not set")
      }
      validate_string($rhn_channel)
      if size($rhn_channel) == 0 {
        fail("${title}::\$rhn_channel not set")
      }
      validate_string($root_dn)
      if size($root_dn) == 0 {
        fail("${title}::\$root_dn not set")
      }
      validate_string($root_dn_pwd)
      if size($root_dn_pwd) == 0 {
        fail("${title}::\$root_dn_pwd not set")
      }
      validate_string($server_admin)
      if size($server_admin) == 0 {
        fail("${title}::\$server_admin not set")
      }
      validate_string($server_admin_pwd)
      if size($server_admin_pwd) == 0 {
        fail("${title}::\$server_admin_pwd not set")
      }
      validate_string($ldap_vname)
      if size($ldap_vname) > 0 {
        unless is_ip_address($ldap_vip) {
          fail("${ldap_vip} must be a valid IP address")
        }
      } # ldap_vname > 0

      if $ssl == 'yes' {
        validate_string($capem)
        if size($capem) == 0 {
          fail("${title}::\$capem not set")
        }
        # AB: if ldap_vname is set, we use it as the server
        # certificate's CN (common name). This happens if we are
        # behind a load balancer.
        if size($ldap_vname) > 0 {
          $server_cn = $ldap_vname
        } else {
          $server_cn = $fqdn
        } # ldap_vname
      } # ssl on

      if $mmr == 'yes' {
        validate_string($start_replication)
        if size($start_replication) == 0 {
          fail("${title}::\$start_replication not set")
        }
      } # mmr on
    } # puppet >= 3.0 and < 3.6

    default: {
      fail("Puppet version ${::puppetversion} not supported.")
    } # unsupported puppet versions
  } # case

  # AB: calculated variables
  $cap12_file        = "${slapd_path}/ca.p12"
  $capem_file        = "${slapd_path}/ca.pem"
  $capem_run         = "${slapd_path}/ca.run"
  $idle_timeout_ldif = "${slapd_path}/idle_timeout.ldif"
  $idle_timeout_run  = "${slapd_path}/idle_timeout.run"
  $mmr_ldif_run      = "${slapd_path}/modify_mmr.run"
  $mmr_ldif          = "${slapd_path}/modify_mmr.ldif"
  $nss_noise         = "${slapd_path}/noise.txt"
  $root_dn_pwd_file  = "${slapd_path}/pwdfile"
  $services          = ['dirsrv', 'dirsrv-admin']
  $srv_keypair_run   = "${slapd_path}/srv.run"
  $ssl_ldif_run      = "${slapd_path}/modify_ssl.run"
  $ssl_ldif          = "${slapd_path}/modify_ssl.ldif"
  $ssl_pin           = "${slapd_path}/pin.txt"
  if size($ldap_vname) > 0 {
    $iptables_nat        = [
      {
        chain    => 'PREROUTING',
        comment  => 'LDAP',
        dip      => $ldap_vip,
        dport    => '389',
        protocol => 'tcp',
      },
      {
        chain    => 'PREROUTING',
        comment  => 'LDAPS',
        dip      => $ldap_vip,
        dport    => '636',
        protocol => 'tcp',
      },
    ]
  } # ldap_vname > 0

  case $::operatingsystem {
    'CentOS': {
      $ldap_srv_pkg = '389-ds'
    } # CentOS

    'RedHat': {
      $ldap_srv_pkg = 'redhat-ds'
    } # RedHat

    default: {
      fail("${::operatingsystem} not supported")
    }
  } # case

  $srv_packages = [
    $ldap_srv_pkg,
    'xorg-x11-fonts-100dpi',
    'xorg-x11-fonts-75dpi',
    'xorg-x11-fonts-ISO8859-1-100dpi',
    'xorg-x11-fonts-ISO8859-1-75dpi',
    'xorg-x11-fonts-ISO8859-14-100dpi',
    'xorg-x11-fonts-ISO8859-14-75dpi',
    'xorg-x11-fonts-ISO8859-15-100dpi',
    'xorg-x11-fonts-ISO8859-15-75dpi',
    'xorg-x11-fonts-ISO8859-2-100dpi',
    'xorg-x11-fonts-ISO8859-2-75dpi',
    'xorg-x11-fonts-ISO8859-9-100dpi',
    'xorg-x11-fonts-ISO8859-9-75dpi',
    'xorg-x11-fonts-Type1',
    'xorg-x11-fonts-cyrillic',
    'xorg-x11-fonts-ethiopic',
    'xorg-x11-fonts-misc',
    'xorg-x11-xauth',
  ]
} # end ldap::server::params
