# == Define: yum::push::package
#
# Push package to yum_local YUM repo.
# NOTE: The named file (${name}.rpm) must be in
#   modules/yum/files/var/lib/yum/yum_local for this to work!
#
# === Parameters
#
# None
#
# === Examples
#
# yum::push::package { 'condor-8.2.2-265643.rhel6.5.x86_64': }
#
# === Authors
#
# Author <author@domain.tld>
#
# === Copyright
#
# No copyright expressed, or implied.
#
define yum::push::package () {

  # uses the yum_local YUM repo
  include yum::repo::yum_local

  # need to wrap to allow multiple calls
  if ! defined ( Package['createrepo'] ) {
    package { 'createrepo': ensure => 'installed' }
  }

  file { "/var/lib/yum/yum_local/${::yum::push::package::name}.rpm":
    ensure  => 'file',
    source  => "puppet:///modules/yum/var/lib/yum/sws/${::yum::push::package::name}.rpm",
    owner   => 'root',
    group   => 'root',
    mode    => '644',
    require => [File['/var/lib/yum/yum_local'], Yumrepo['yum_local'],],
    notify  => Exec["yum_local refresh for ${::yum::push::package::name}"],
  }

  exec { "yum_local refresh for ${::yum::push::package::name}":
    cwd         => '/var/lib/yum/yum_local',
    command     => '/usr/bin/createrepo /var/lib/yum/yum_local',
    refreshonly => 'true',
    require     => Package['createrepo'],
  }

}
