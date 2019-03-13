module OpenAssets
  class Api
    # RPC do not use
    # Must set mock to :provider:
    def initialize(config = nil)
      @config = {:network => 'mainnet',
                 :provider => 'bitcoind', :cache => 'cache.db',
                 :dust_limit => 600, :default_fees => 10000, :min_confirmation => 1, :max_confirmation => 9999999,
                }
      @config.update(config) if config
      OpenAssets.configuration = @config
      raise OpenAssets::Error, 'specified unsupported provider.' unless @config[:provider] == 'bitcoind'
      @tx_cache = Cache::TransactionCache.new(@config[:cache])
      @output_cache = Cache::OutputCache.new(@config[:cache])
      change_network
    end
  end
end
