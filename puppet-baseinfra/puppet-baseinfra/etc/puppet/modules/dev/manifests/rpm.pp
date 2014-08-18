# == Class: dev::rpm
#
# This construction class installs and configures the RPM
# dev function.
#
# Supported OSses and versions:
# * CentOS
#   * 6
# * RHEL
#   * 6
#
# === Dependencies
#
# stdlib
#
# === Parameters
#
# All parameters used as an configuration interface are
# placed in the dev::rpm::params class.
#
# === Variables
#
# === Examples
#
# === Authors
#
# Allard Berends <allard.berends@example.com> (AB)
#
# === Copyright
#
# Copyright 2014 Allard Berends
#
# === Bugs
#
class dev::rpm inherits dev::rpm::params {
  include stdlib

  $rpm_root = "${rpm_home}/rpm"
  $rpm_dirs = [
    $rpm_root,
    "${rpm_root}/BUILD",
    "${rpm_root}/BUILDROOT",
    "${rpm_root}/RPMS",
    "${rpm_root}/SOURCES",
    "${rpm_root}/SPECS",
    "${rpm_root}/SRPMS",
    "${rpm_root}/tmp"
  ]

  package{$rpm_packages:
    ensure => installed,
  }

  group{$rpm_group:
    ensure     => present,
    gid        => $rpm_gid,
    require    => Package[$rpm_packages],
  }

  user{$rpm_user:
    ensure     => present,
    comment    => 'RPM build user',
    home       => $rpm_home,
    gid        => $rpm_gid,
    uid        => $rpm_uid,
    managehome => true,
  }

  file{$rpm_dirs:
    ensure     => directory,
    group      => $rpm_group,
    owner      => $rpm_user,
    mode       => '0755',
    require    => User[$rpm_user],
  }

  file{$rpm_key_file:
    ensure     => file,
    group      => $rpm_group,
    owner      => $rpm_user,
    mode       => '0644',
    content    => $gpg_sign_key,
    require    => User[$rpm_user],
  }

  $import_gpg_key = 'import-gpg-key'
  exec{$import_gpg_key:
    command => "/bin/su - ${rpm_user} -c \"/usr/bin/gpg --import ${rpm_key_file}\"",
    onlyif  => "/usr/bin/test ! -d ${rpm_home}/.gnupg",
    require => File[$rpm_key_file],
  }

  $gpg_key = get_gpg_key($gpg_sign_key)
  file{$rpm_macros:
    ensure     => file,
    group      => $rpm_group,
    owner      => $rpm_user,
    mode       => '0644',
    content    => template('dev/rpm/rpmmacros.erb'),
    require    => Exec[$import_gpg_key],
  }

} # end dev::rpm
