module Bitcoin2Graphdb
  class Migration
    attr_reader :blockchain
    attr_reader :neo4j

    def initialize(config)
      @blockchain = Bitcoin::BlockchainProvider.new(config[:bitcoin])
      @neo4j = Neo4j::Database.new(config[:neo4j])
    end
  end
end