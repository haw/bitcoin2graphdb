module BitcoinMock

  def setup_mock
    provider = Bitcoin2Graphdb::Bitcoin::BlockchainProvider.new({:cache => ':memory:', :network => 'testnet'})

    testnet_mock = double('BitcoinCoreProviderTestnet Mock')
    load_block(testnet_mock)
    load_tx(testnet_mock)
    allow(provider.api).to receive(:provider).and_return(testnet_mock)
    Bitcoin2Graphdb::Bitcoin.provider = provider
  end

  def load_tx(provider_mock)
    allow(provider_mock).to receive(:getrawtransaction).with('f0315ffc38709d70ad5647e22048358dd3745f3ce3874223c80a7c92fab0c8ba', 1).and_return(fixture_file('tx/f0315ffc38709d70ad5647e22048358dd3745f3ce3874223c80a7c92fab0c8ba.json'))
  end

  def load_block(provider_mock)
    block_hash_0 = '000000000933ea01ad0ee984209779baaec3ced90fa3f408719526f8d77f4943'
    allow(provider_mock).to receive(:getblockhash).with(0).and_return(block_hash_0)
    allow(provider_mock).to receive(:getblock).with(block_hash_0).and_return(fixture_file('block/000000000933ea01ad0ee984209779baaec3ced90fa3f408719526f8d77f4943.json'))
  end

end

