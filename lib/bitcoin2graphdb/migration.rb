require 'base'
module Bitcoin2Graphdb
  class Migration

    def initialize(config)
      Graphdb.configure do |c|
        c.neo4j_server = config[:neo4j][:server]
        c.extensions = config[:extensions] unless config[:extensions].nil?
      end
      Bitcoin2Graphdb::Bitcoin.provider = Bitcoin2Graphdb::Bitcoin::BlockchainProvider.new(config[:bitcoin])
      Neo4j::Session.open(:server_db, config[:neo4j][:server],
                          {basic_auth: config[:neo4j][:basic_auth], initialize: {request: {open_timeout: 2, timeout: 600}}})
    end

    def run
      loop {
        run_with_height(current_block_height + 1)
      }
    end

    def run_with_height(block_height)
      puts "start migration for block height = #{block_height}. #{Time.now}"
      Neo4j::Transaction.run do |tx|
        begin
          Graphdb::Model::Block.create_from_block_height(block_height)
          @block_height = block_height
        rescue OpenAssets::Provider::ApiError => e
          if e.message == '{"code"=>-8, "message"=>"Block height out of range"}'
            puts "Block height out of range. sleep 10 min."
            sleep 600
          else
            tx.failure
            raise e
          end
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