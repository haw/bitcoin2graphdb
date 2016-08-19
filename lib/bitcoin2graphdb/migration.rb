require 'base'
module Bitcoin2Graphdb
  class Migration

    attr_reader :sleep_interval

    def initialize(config)
      Graphdb.configure do |c|
        c.neo4j_server = config[:neo4j][:server]
        c.extensions = config[:extensions] unless config[:extensions].nil?
      end
      neo4j_config = {basic_auth: config[:neo4j][:basic_auth], initialize: neo4j_timeout_ops(config)}
      Bitcoin2Graphdb::Bitcoin.provider = Bitcoin2Graphdb::Bitcoin::BlockchainProvider.new(config[:bitcoin])
      Neo4j::Session.open(:server_db, config[:neo4j][:server], neo4j_config)
      @sleep_interval = config[:bitcoin][:sleep_interval].nil? ? 600 : config[:bitcoin][:sleep_interval].to_i

      Graphdb::Model.constants.each {|const_name| Graphdb::Model.const_get(const_name)}
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
            puts "Block height out of range. sleep #{@sleep_interval} seconds."
            sleep @sleep_interval
          else
            tx.failure
            raise e
          end
        end
      end
      puts "end migration for block height #{block_height}. #{Time.now}"
    end

    def repair_assign_txs(block_height)
      Neo4j::Transaction.run do |tx|
        begin
          block = Graphdb::Model::Block.with_height(block_height).first
          if block
            hash = Bitcoin2Graphdb::Bitcoin.provider.block(block.block_hash)
            tx_list = block.transactions.to_a
            hash['tx'].each do |txid|
              target = tx_list.find{|t|t.txid == txid}
              if target.nil?
                block.transactions << Graphdb::Model::Transaction.with_txid(txid).first
                puts "repair tx = #{txid}"
              end
            end
            block.save!
          end
        rescue => e
          tx.failure
          raise e
        end
      end
    end

    def remove_block(block_height)
      Neo4j::Transaction.run do |tx|
        begin
          block = Graphdb::Model::Block.with_height(block_height).first
          if block.nil?
            puts "block height #{block_height} does not exist."
          else
            block.destroy
            puts "block height #{block_height} is deleted."
          end
        rescue => e
          puts e.message
          tx.failure
        end
      end
    end

    def import_tx(txid)
      Neo4j::Transaction.run do |tx|
        begin
          tx = Graphdb::Model::Transaction.with_txid(txid).first
          if tx.nil?
            Graphdb::Model::Transaction.create_from_txid(txid)
            puts "import #{txid} tx."
          else
            puts "txid #{txid} is already exist."
          end
        rescue => e
          puts e.message
          tx.failure
        end
      end
    end

    def remove_tx(txid)
      Neo4j::Transaction.run do |tx|
        begin
          tx = Graphdb::Model::Transaction.with_txid(txid).first
          if tx.nil?
            puts "txid #{txid} does not exist."
          else
            tx.destroy
            puts "tixd #{txid} is deleted."
          end
        rescue => e
          puts e.message
          tx.failure
        end
      end
    end

    private
    def current_block_height
      return @block_height if @block_height
      block = Graphdb::Model::Block.latest.first
      @block_height = block.nil? ? -1 : block.height
    end

    def neo4j_timeout_ops(config)
      if config[:neo4j][:initialize]
        config[:neo4j][:initialize]
      else
        {request: {timeout: 600, open_timeout: 2}}
      end
    end

  end
end