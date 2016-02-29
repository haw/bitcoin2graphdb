require 'spec_helper'

describe Graphdb::Model::Transaction do

  it 'create tx node' do
    tx = Graphdb::Model::Transaction.from_txid('f0315ffc38709d70ad5647e22048358dd3745f3ce3874223c80a7c92fab0c8ba')
    expect(tx.hex).to eq('01000000010000000000000000000000000000000000000000000000000000000000000000ffffffff0e0420e7494d017f062f503253482fffffffff0100f2052a010000002321021aeaf2f8638a129a3156fbe7e5ef635226b0bafd495ff03afe2c843d7e3a4b51ac00000000')
    expect(tx.txid).to eq('f0315ffc38709d70ad5647e22048358dd3745f3ce3874223c80a7c92fab0c8ba')
    expect(tx.version).to eq(1)
    expect(tx.lock_time).to eq(0)
    expect(tx.block_hash).to eq('00000000b873e79784647a6c82962c70d228557d24a747ea4d1b8bbe878e1206')
    expect(tx.block_time).to eq(Time.at(1296688928))
    expect(tx.time).to eq(Time.at(1296688928))
    expect(tx.confirmations).to eq(721325)
  end

end