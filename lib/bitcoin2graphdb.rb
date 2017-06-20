require 'bitcoin'
require 'openassets'
require 'bitcoin2graphdb/version'

module Bitcoin2Graphdb
  autoload :Bitcoin, 'bitcoin2graphdb/bitcoin'
  autoload :Migration, 'bitcoin2graphdb/migration'
end
