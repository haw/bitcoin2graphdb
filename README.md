# Bitcoin2Graphdb [![Build Status](https://travis-ci.org/haw-itn/bitcoin2graphdb.svg?branch=master)](https://travis-ci.org/haw-itn/bitcoin2graphdb) [![Gem Version](https://badge.fury.io/rb/bitcoin2graphdb.svg)](https://badge.fury.io/rb/bitcoin2graphdb) [![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)

A tool for import Bitcoin blockchain data into neo4j database.

![neo4jgraph](https://raw.githubusercontent.com/wiki/haw-itn/bitcoin2graphdb/images/graph.png)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bitcoin2graphdb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bitcoin2graphdb

## Requirements

This tool requires the following software.

* Bitcoin Core
* Neo4j

## Configuration

This tool requires the following configuration file.

```yaml
bitcoin2graphdb:
  bitcoin:
    network: 'mainnet or testnet or regtest'
    rpc:
      user: 'Bitcoin Core rpc user.'
      password: 'Bitcoin Core rpc password.'
      schema: 'Bitcoin Core server schema. ex, http'
      port: 'Bitcoin Core server port. ex, 8332'
      host: 'Bitcoin Core server host. ex, xxx.xxx.xxx.xxx'
    sleep_interval: 600
    min_block_confirmation: 2
  neo4j:
    server: 'neo4j server url. ex, http://localhost:7474'
    basic_auth:
      username: 'neo4j username'
      password: 'neo4j password'
    initialize:
      request:
        timeout: 600
        open_timeout: 2
```

## Usage

* Show usage
```
$ bitcoin2graphdb help
```

* Start bitcoin2graphdb daemon
```
$ bitcoin2graphdb start -c <configuration file path>
```

* Stop bitcoin2graphdb daemon
```
$ bitcoin2graphdb stop
```

## Extensions

Bitcoin2Graphdb currently supports following extensions.

|Extension Key Name|Description|
|:-----------|:------------|
|open_assets| Add Open Assets Protocol support. If this extension is enabled, the asset quantity and Graphdb::Model::AssetId association will be added to the Graphdb::Model::TxOut.|
* Open Assets Protocol

To enable extension, add an extension key name to enable the Configuration file like following.

```yaml
bitcoin2graphdb:
...
  extensions:
   - 'open_assets'
```

# Testing

When you run rspec, you need to run neo4j test server(http://localhost:7475) in advance.
Others are the same as normal rspec.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/haw-itn/bitcoin2graphdb.

## License

The MIT License (MIT)

Copyright (c) 2016 HAW International Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
