require 'base'
module Bitcoin2Graphdb
  class Migration

    attr_reader :sleep_interval

    def initialize(config)
      Graphdb.configure do |c|
        c.neo4j_server = config[:neo4j][:server]
        c.extensions = config[:extensions] unless config[:extensions].nil?
      end
      Bitcoin2Graphdb::Bitcoin.provider = Bitcoin2Graphdb::Bitcoin::BlockchainProvider.new(config[:bitcoin])
      neo4j_adaptor = create_neo4j_adaptor(config)
      Neo4j::ActiveBase.on_establish_session { Neo4j::Core::CypherSession.new(neo4j_adaptor) }
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
      Neo4j::ActiveBase.run_transaction do |tx|
        begin
          Graphdb::Model::Block.create_from_block_height(block_height)
          @block_height = block_height
        rescue OpenAssets::Provider::ApiError, Bitcoin2Graphdb::Error => e
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
      Neo4j::ActiveBase.run_transaction do |tx|
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
      Neo4j::ActiveBase.run_transaction do |tx|
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
      Neo4j::ActiveBase.run_transaction do |tx|
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
      Neo4j::ActiveBase.run_transaction do |tx|
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

    def search_invalid_oa_tx
      puts "start get_invalid_oa_tx"
      Graphdb::Model::AssetId.all.each{|asset_id|
        asset_id.issuance_txs.each{|issuance_tx| asset_outputs(issuance_tx.txid)}
      }
      puts "get_invalid_oa_tx end."
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

    def create_neo4j_adaptor(config)
      uri = URI(config[:neo4j][:server])
      case uri.scheme
      when 'http'
        faraday_configurator = proc do |faraday|
          require 'typhoeus'
          require 'typhoeus/adapters/faraday'
          faraday.adapter :typhoeus
          faraday.options.merge!(neo4j_timeout_ops(config)[:request])
        end
        neo4j_config = {basic_auth: config[:neo4j][:basic_auth], faraday_configurator: faraday_configurator}
        Neo4j::Core::CypherSession::Adaptors::HTTP.new(config[:neo4j][:server], neo4j_config)
      when 'bolt'
        Neo4j::Core::CypherSession::Adaptors::Bolt.new(config[:neo4j][:server], neo4j_bolt_options(config))
      else
        fail ArgumentError, "Invalid URL: #{uri.inspect}"
      end
    end

    def neo4j_bolt_options(config)
      if config[:neo4j][:options]
        config[:neo4j][:options]
      else
        { ssl: false }
      end
    end

    def asset_outputs(txid)
      tx = Graphdb::Model::Transaction.with_txid(txid).first
      not_oa_tx = Bitcoin2Graphdb::Bitcoin.provider.oa_outputs(txid, false).find{|o|!o['asset_id'].nil?}.nil?
      tx.outputs.each do |o|
        unless o.asset_id.nil?
          puts "This tx is not oa. txid = #{txid}" if not_oa_tx
          asset_outputs(o.out_point.transaction.txid) unless o.out_point.nil?
        end
      end
    end

  end
end