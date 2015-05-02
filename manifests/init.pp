class yum {

  # install the yum package
  package{'yum': ensure => 'latest' }

  # make sure yum.repos.d directory exists
  file {'/etc/yum.repos.d': ensure => 'directory' }

  # making sure gpg key directories exist
  # where to the gpg keys go?
  $gpgkey_location = $::lsbmajdistrelease ? {
    '4'     => '/usr/share/rhn',
    default => '/etc/pki/rpm-gpg',
  }
  # make sure the directory exists
  if ! defined(File["${gpgkey_location}"]) {
    file {"${gpgkey_location}": ensure => 'directory' }
  }

}
