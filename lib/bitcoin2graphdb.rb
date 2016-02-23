require "bitcoin2graphdb/version"
require 'active_support/all'

module Bitcoin2Graphdb
  autoload :Bitcoin, 'bitcoin2graphdb/bitcoin'
  autoload :Neo4j, 'bitcoin2graphdb/neo4j'
  autoload :Migration, 'bitcoin2graphdb/migration'

end
