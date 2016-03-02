module Bitcoin2Graphdb
  class Migration

    def initialize(config)
      Bitcoin2Graphdb::Bitcoin.provider = Bitcoin2Graphdb::Bitcoin::BlockchainProvider.new(config[:bitcoin])
      Neo4j::Session.open(:server_db, config[:neo4j][:server_url])
    end

    def run
      loop {
        run_with_height(current_block_height + 1)
      }
    end

    def run_with_height(block_height)
      puts "start migration for block height = #{block_height}. #{Time.now}"
      begin
        Neo4j::Transaction.run do |tx|
          Graphdb::Model::Block.create_from_block_height(block_height)
          @block_height = block_height
        end
      rescue OpenAssets::Provider::ApiError => e
        if e.message == '{"code"=>-8, "message"=>"Block height out of range"}'
          puts "Block height out of range. sleep 10 min."
          sleep 600
        end
      end
      puts "end migration for block height #{block_height}. #{Time.now}"
    end

    private
    def current_block_height
      return @block_height if @block_height
      block = Graphdb::Model::Block.latest
      @block_height = block.nil? ? -1 : block.height
    end

  end
end