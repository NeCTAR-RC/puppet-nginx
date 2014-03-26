class nginx {

  package { 'nginx':
    ensure => installed,
  }

  service { 'nginx':
    ensure  => running,
    require => Package['nginx'],
  }

  define proxy( $port, $upstreams, $ssl=false, $client_timeout='60s', $nagios_check=true, $chunking=false, $path='/') {

    $admin_hosts = hiera('iptables_templates::admin_hosts', [])
    $nagios_hosts = hiera('nagios::hosts', [])

    file { "/etc/nginx/sites-available/${name}.conf":
      ensure  => present,
      content => template('nginx/proxy.conf.erb'),
      notify  => Service['nginx'],
      require => Package['nginx'],
    }

    file { "/etc/nginx/sites-enabled/${name}.conf":
      ensure => link,
      target => "/etc/nginx/sites-available/${name}.conf",
      notify => Service['nginx'],
    }

    firewall { "100 ${name}":
      dport  => $port,
      proto  => tcp,
      action => accept,
    }

    if $nagios_check {
      if $ssl {
        nagios::service { "http_${port}":
          check_command => "https_port!${port}";
        }
      }
      else {
        nagios::service { "http_${port}":
          check_command => "http_port!${port}";
        }
      }
    }
  }

  file { '/etc/nginx/ssl':
    ensure  => directory,
    require => Package['nginx'],
  }

  File <| tag == 'sslcert' |> {
    notify +> Service['nginx'],
  }

  file {'/etc/nginx/sites-enabled':
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
    notify  => Service['nginx'],
    require => Package['nginx'],
  }
  
  file {'/etc/nginx/sites-available':
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
    require => Package['nginx'],
  }

}
