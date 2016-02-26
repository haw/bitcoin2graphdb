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
      end

      def block(block_hash)
        api.provider.getblock(block_hash)
      end

      def block_hash(block_height)
        api.provider.getblockhash(block_height)
      end

      def tx(txid)
        api.provider.getrawtransaction(txid, 1)
      end

    end
  end
end