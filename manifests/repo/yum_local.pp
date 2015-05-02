# == Class: yum::repo::yum_local
#
# Defines the yum_local repo to be used with yum::push::package
#
# === Parameters
#
# None
#
# === Variables
#
# None
#
# === Examples
#
# class { 'yum::repo::yum_local': }
#
# include yum::repo::yum_local
# 
# === Authors
#
# Author <author@domain.tld>
#
# === Copyright
#
# No copyright expressed, or implied.
#
class yum::repo::yum_local { 

  include yum

  file { '/var/lib/yum/yum_local':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '755',
    require => Package['yum'],
  }

  yumrepo { 'yum_local':
    descr    => 'Local YUM repo.',
    baseurl  => 'file:/var/lib/yum/yum_local',
    enabled  => '1',
    gpgcheck => '0',
    require  => File['/var/lib/yum/yum_local'],
  }

}
