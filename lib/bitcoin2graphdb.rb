require 'active_support/all'
require 'bitcoin'
require 'openassets'
require 'neo4j'

module Bitcoin2Graphdb
  autoload :Bitcoin, 'bitcoin2graphdb/bitcoin'
  autoload :Graphdb, 'bitcoin2graphdb/graphdb'
end
