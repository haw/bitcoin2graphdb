# Bitcoin2Graphdb

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
    network: 'mainnet or testnet'
    rpc:
      user: 'Bitcoin Core rpc user.'
      password: 'Bitcoin Core rpc password.'
      schema: 'Bitcoin Core server schema. ex, http'
      port: 'Bitcoin Core server port. ex, 8332'
      host: 'Bitcoin Core server host. ex, xxx.xxx.xxx.xxx'
  neo4j:
    server: 'neo4j server url. ex, http://localhost:7474'
```

## Usage

* Start bitcoin2graphdb daemon
```
$ bitcoin2graphdb start -c <configuration file path>
```

* Stop bitcoin2graphdb daemon
```
$ bitcoin2graphdb stop 
```

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

