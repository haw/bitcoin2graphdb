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
    load_tx_mock(provider_mock, 'f0315ffc38709d70ad5647e22048358dd3745f3ce3874223c80a7c92fab0c8ba')
    load_tx_mock(provider_mock, '8a750f083b2d7b5166be2ea897a073830a7e5cf7dafdb54f0a6c9151b39de60b')
    load_tx_mock(provider_mock, 'f1e579409e5d6ae20424f71b5cf46b8a7fd5deb62a0b3da989c33957cf0b1b92')
    load_tx_mock(provider_mock, 'b50ddb740dae9b2b652dfe4db84e2d594e02ca9323adf3e614e1edd8b1ea6f1e')
    load_tx_mock(provider_mock, 'a983a4d0326ddb177107431515832205c843a61f0bb518be459134f3bdd035db')
  end

  def load_block(provider_mock)
    load_block_mock(provider_mock, 0, '000000000933ea01ad0ee984209779baaec3ced90fa3f408719526f8d77f4943')
    load_block_mock(provider_mock, 722039, '0000000000001521a7fd176803e2a7c3b327617319837144d6fa326fad56641e')
  end

  def load_block_mock(mock, block_height, block_hash)
    allow(mock).to receive(:getblockhash).with(block_height).and_return(block_hash)
    allow(mock).to receive(:getblock).with(block_hash).and_return(fixture_file("block/#{block_hash}.json"))
  end

  def load_tx_mock(mock, txid)
    allow(mock).to receive(:getrawtransaction).with(txid, 1).and_return(fixture_file("tx/#{txid}.json"))
  end

end

