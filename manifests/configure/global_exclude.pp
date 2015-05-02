# == Define: yum::configure::global_exclude
#
# Configure global yum excludes (those that show up in /etc/yum.conf)
#
# === Parameters
#
# [*exclude*]
#   - an array of strings which are concatenated into a single string for
#   setting exclude via augeas
#
# === Examples
#
#  yum::configure::global_exclude {'/etc/yum.conf':
#    exclude => ['zz_local_dns_cache',],
#  }
#
#  You can append to the list of global excludes using the +> operator.
#
#  Yum::Configure::Global_exclude['/etc/yum.conf'] {
#    exclude +> ['ImageMagick*', 'firefox',],
#  }
#
# === Authors
#
# Author <author@domain.tld>
#
# === Copyright
#
# No copyright expressed, or implied.
#
define yum::configure::global_exclude ($exclude = '') {

  # need yum around to configure
  include yum

  # take exclude list and concatenate into single full_exclude_string
  $full_exclude_string = inline_template("<%= exclude.flatten.join(' ') %>")

  # set exclude value using full_exclude_string
  augeas {'yum.conf global excludes':
    context => '/files/etc/yum.conf/main',
    changes => "set exclude \"${full_exclude_string}\"",
    onlyif  => "match /files/etc/yum.conf/main/exclude not_include \"${full_exclude_string}\"",
  }

}
