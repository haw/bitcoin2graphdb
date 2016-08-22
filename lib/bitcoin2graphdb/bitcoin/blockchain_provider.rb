module Bitcoin2Graphdb
  module Bitcoin

    class << self
      attr_accessor :provider

      def open(config)
        self.provider = BlockchainProvider.new(config)
      end

    end

    class BlockchainProvider

      attr_reader :api

      def initialize(config)
        @api = OpenAssets::Api.new(config)
        @api
      end

      def block(block_hash)
        b = api.provider.getblock(block_hash)
        raise OpenAssets::Provider::ApiError.new('{"code"=>-8, "message"=>"Block height out of range"}') if b['confirmations'] < min_block_confirmation
        b
      end

      def block_hash(block_height)
        api.provider.getblockhash(block_height)
      end

      def tx(txid)
        api.provider.getrawtransaction(txid, 1)
      end

      def oa_outputs(txid, cache = true)
        api.get_outputs_from_txid(txid, cache)
      end

      private
      def min_block_confirmation
        api.config[:min_block_confirmation] ? api.config[:min_block_confirmation] : 2
      end

    end
  end
end