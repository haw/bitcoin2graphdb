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

  end

  def load_block(provider_mock)
    block_hash_0 = '000000000933ea01ad0ee984209779baaec3ced90fa3f408719526f8d77f4943'
    allow(provider_mock).to receive(:getblockhash).with(0).and_return(block_hash_0)
    allow(provider_mock).to receive(:getblock).with(block_hash_0).and_return(BLOCK_0)

  end

  BLOCK_0 ={
      'hash' => '000000000933ea01ad0ee984209779baaec3ced90fa3f408719526f8d77f4943',
      'confirmations' => 721047,
      'size' => 285,
      'height' => 0,
      'version' => 1,
      'merkleroot' => '4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b',
      'tx' => ['4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b'],
      'time' => 1296688602,
      'nonce' => 414098458,
      'bits' => '1d00ffff',
      'difficulty' => 1.00000000,
      'chainwork' => '0000000000000000000000000000000000000000000000000000000100010001',
      'nextblockhash' => '00000000b873e79784647a6c82962c70d228557d24a747ea4d1b8bbe878e1206'
  }
end

