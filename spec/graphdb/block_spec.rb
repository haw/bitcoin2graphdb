require 'spec_helper'
describe Graphdb::Model::Block do

  it 'create block node' do
    block = Graphdb::Model::Block.new(0)
    expect(block.block_hash).to eq('000000000933ea01ad0ee984209779baaec3ced90fa3f408719526f8d77f4943')
    expect(block.size).to eq(285)
    expect(block.height).to eq(0)
    expect(block.version).to eq(1)
    expect(block.merkle_root).to eq('4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b')
    expect(block.time).to eq(Time.at(1296688602))
    expect(block.bits).to eq('1d00ffff')
    expect(block.difficulty).to eq(1.00000000)
    expect(block.chain_work).to eq('0000000000000000000000000000000000000000000000000000000100010001')
    expect(block.next_block_hash).to eq('00000000b873e79784647a6c82962c70d228557d24a747ea4d1b8bbe878e1206')
    expect(block.nonce).to eq(414098458)
  end

end