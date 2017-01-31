# kibana5

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with kibana5](#setup)
    * [What kibana5 affects](#what-kibana5-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with kibana5](#beginning-with-kibana5)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module installs and configures Kibana v5.x.x on ubuntu hosts. (It may
work on other deb-based distributions but that is currently untested.)

## Setup

### Setup Requirements 

This module does not handle any dependencies (such as Java.) These must be
installed separately before the module is run.

## Usage

The only required options are the kibana version (eg 5.1.2).

For example:
    class { 'kibana5':
      kibana_version => '5.1.2',
      listen_host    => '10.0.0.3',
      listen_port    => 5601,
    }

## Reference

# Parameters

 * `kibana_version`
 Kibana version. 
 Example: '5.1.2'

 * `elasticsearch_url`
 Elasticsearch URL
 Example: 'http://localhost:9200'

 * `listen_host`
 Address to listen on
 Default: 'localhost'

 * `listen_port`
 Port to listen on.
 Default: 5601

 * `server_name`
 Cosmetic name of the kibana server.
 Default: FQDN

 * `elasticsearch_user`
 * `elasticsearch_pass`
 Basic authentication (optional) for Kibana to perform ES functions
 This is NOT used for user authentication.

 * `automatic_restart`
 Whether to automatically restart the service when there are configuration
 changes.

## Limitations

Currently, only Ubuntu 14.04 has been tested.

## Development

Issues and pull requests are available through Github at https://github.com/disconn3ct/puppet-kibana5

