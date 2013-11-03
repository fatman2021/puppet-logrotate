# Internal: Install logrotate and configure it to read from /etc/logrotate.d
#
# Examples
#
#   include logrotate::base
class logrotate::base (
  $package_ensure  = 'latest',
  $gentoo_keywords = '',
  $gentoo_use      = '',
) {

  if $::osfamily == 'Gentoo' {
    portage::package { 'app-admin/logrotate':
      keywords => $gentoo_keywords,
      use      => $gentoo_use,
      ensure   => $package_ensure,
    }
  } else {
    package { 'logrotate':
      ensure => $package_ensure,
    }
  }

  file {
    '/etc/logrotate.conf':
      ensure  => file,
      mode    => '0444',
      source  => 'puppet:///modules/logrotate/etc/logrotate.conf';
    '/etc/logrotate.d':
      ensure  => directory,
      mode    => '0755';
    '/etc/cron.daily/logrotate':
      ensure  => file,
      mode    => '0555',
      source  => 'puppet:///modules/logrotate/etc/cron.daily/logrotate';
  }

  case $::osfamily {
    'Debian': {
      include logrotate::defaults::debian
    }
    'RedHat': {
      include logrotate::defaults::redhat
    }
    'SuSE': {
      include logrotate::defaults::suse
    }
    'Gentoo': {
      include logrotate::defaults::gentoo
    }
    default: { }
  }
}
