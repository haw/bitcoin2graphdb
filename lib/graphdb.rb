require 'neo4j'

module Graphdb
  autoload :Model, 'graphdb/model'
  autoload :Configuration, 'graphdb/configuration'

  def self.configuration
    @configuration ||= Graphdb::Configuration.new
  end

  def self.configure
    yield configuration if block_given?
    configuration.load_extensions
  end

  Neo4j::Config[:association_model_namespace] = Graphdb::Model
end