require 'neography'
module  Bitcoin2Graphdb
  module Neo4j
    class Database

      attr_reader :neo

      def initialize(config)
        @neo = Neography::Rest.new(config)
      end

    end
  end
end