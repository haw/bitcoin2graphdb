module Graphdb
  class Configuration

    attr_accessor :neo4j_server
    attr_accessor :extensions

    def initialize
      @extensions = {}
      @neo4j_server = 'http://localhost:7474'
    end

    def load_extensions
    end

  end
end