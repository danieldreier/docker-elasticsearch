node default {
  class {'java':
    require => Class['apt'],
  }
  class { 'apt':
    always_apt_update    => true,
  }

  apt::source { 'elasticsearch_1.1':
    location    => 'http://packages.elasticsearch.org/elasticsearch/1.1/debian',
    release     => 'stable',
    repos       => 'main',
    key         => 'D88E42B4',
    include_src => false,
  }

  class { 'elasticsearch':
    config                   => {
      'node'                 => {
        'name'               => 'elasticsearch001'
      },
      'index'                => {
        'number_of_replicas' => '1',
        'number_of_shards'   => '5'
      },
      'network'              => {
        'host'               => $::ipaddress
      }
    },
    require                  => [Apt::Source['elasticsearch_1.1'],
                                Class['java']],
  }
}
