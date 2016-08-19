module BitcoinMock

  def setup_mock
    provider = Bitcoin2Graphdb::Bitcoin::BlockchainProvider.new({:cache => ':memory:', :network => 'testnet'})
    testnet_mock = double('BitcoinCoreProviderTestnet Mock')
    load_block(testnet_mock)
    load_tx(testnet_mock)
    allow(provider.api).to receive(:provider).and_return(testnet_mock)
    Bitcoin2Graphdb::Bitcoin.provider = provider
  end

  private

  def load_tx(provider_mock)
    Dir::entries(__dir__ + "/fixtures/tx").each do |file_name|
      next unless file_name.include?(".json")
      txid = file_name.delete(".json")
      json = fixture_file("tx/#{txid}.json")
      allow(provider_mock).to receive(:get_transaction).with(txid, 0).and_return(json['hex'])
      allow(provider_mock).to receive(:get_transaction).with(txid, 1).and_return(json)
      allow(provider_mock).to receive(:getrawtransaction).with(txid, 0).and_return(json['hex'])
      allow(provider_mock).to receive(:getrawtransaction).with(txid, 1).and_return(json)
    end
  end

  def load_block(provider_mock)
    Dir::entries(__dir__ + "/fixtures/block").each do |file_name|
      next unless file_name.include?(".json")
      block_hash = file_name.delete(".json")
      json = fixture_file("block/#{block_hash}.json")
      allow(provider_mock).to receive(:getblockhash).with(json['height']).and_return(block_hash)
      allow(provider_mock).to receive(:getblock).with(block_hash).and_return(json)
    end
  end

end
