# Class: kibana5
# ===========================
#
# This class will install Kibana 5.x.x on an Ubuntu system.
#
# Parameters
# ----------
#
# * `kibana_version`
# Kibana version. 
# Example: '5.1.2'
#
# * `elasticsearch_url`
# Elasticsearch URL
# Example: 'http://localhost:9200'
#
# * `listen_host`
# Address to listen on
# Default: 'localhost'
#
# * `listen_port`
# Port to listen on.
# Default: 5601
#
# * `server_name`
# Cosmetic name of the kibana server.
# Default: FQDN
#
# * `elasticsearch_user`
# * `elasticsearch_pass`
# Basic authentication (optional) for Kibana to perform ES functions
# This is NOT used for user authentication.
#
# * `automatic_restart`
# Whether to automatically restart the service when there are configuration
# changes.
# 
# Examples
# --------
#
# @example
#    class { 'kibana5':
#      kibana_version    => '5.1.2',
#      listen_host       => '10.0.0.3',
#      listen_port       => 5601,
#      elasticsearch_url => 'http://elasticsearch.me:9200',
#    }
#
# Authors
# -------
#
# Dis McCarthy <puppet@gotontheinter.net>
#
# Copyright
# ---------
#
# Copyright 2017 Dis McCarthy, unless otherwise noted.
#
class kibana5 (
  $kibana_version,
  $elasticsearch_url,
  $automatic_restart = true,
  $listen_host = 'localhost',
  $listen_port = 5601,
  $server_name = $::fqdn,
  $elasticsearch_user = undef,
  $elasticsearch_pass = undef,
) {
  validate_string($listen_host)
  validate_integer($listen_port)
  validate_string($server_name)
  validate_string($elasticsearch_url)
  validate_bool($automatic_restart)

  if ($elasticsearch_user and !$elasticsearch_pass) {
    fail("ES password is not present for user '${elasticsearch_user}'")
  } elsif ($elasticsearch_user) {
    validate_string($elasticsearch_user)
    validate_string($elasticsearch_pass)
  }
  staging::file { "kibana-${kibana_version}-${::architecture}.deb":
    source => "https://artifacts.elastic.co/downloads/kibana/kibana-${kibana_version}-${::architecture}.deb",
    notify => Package['kibana'],
  }
  package { 'kibana':
    ensure   => present,
    provider => 'dpkg',
    source   => "/opt/staging/kibana5/kibana-${kibana_version}-${::architecture}.deb",
    require  => Staging::File["kibana-${kibana_version}-${::architecture}.deb"],
  }
  file { '/etc/kibana/kibana.yml':
    ensure  => present,
    mode    => '0640',
    owner   => 'kibana',
    group   => 'kibana',
    content => template('kibana5/kibana.yml.erb'),
    require => Package['kibana'],
  }
  if ($automatic_restart) {
    $svc_subscribe = File['/etc/kibana/kibana.yml']
  } else {
    $svc_subscribe = undef
  }
  service { 'kibana':
    ensure    => running,
    enable    => true,
    subscribe => $svc_subscribe,
  }
}
