require 'spec_helper'
describe Graphdb::Model::Block do

  it 'create association node' do
    block = Graphdb::Model::Block.create_from_block_height(722039)
    expect(block.transactions.length).to eq(4)

    expect(block.transactions).to contain_exactly(
                                      have_attributes(txid: '8a750f083b2d7b5166be2ea897a073830a7e5cf7dafdb54f0a6c9151b39de60b'),
                                      have_attributes(txid: 'f1e579409e5d6ae20424f71b5cf46b8a7fd5deb62a0b3da989c33957cf0b1b92'),
                                      have_attributes(txid: 'b50ddb740dae9b2b652dfe4db84e2d594e02ca9323adf3e614e1edd8b1ea6f1e'),
                                      have_attributes(txid: 'a983a4d0326ddb177107431515832205c843a61f0bb518be459134f3bdd035db'))

    target = block.transactions.find{|t|t.txid == 'f1e579409e5d6ae20424f71b5cf46b8a7fd5deb62a0b3da989c33957cf0b1b92'}
    expect(target.txid).to eq('f1e579409e5d6ae20424f71b5cf46b8a7fd5deb62a0b3da989c33957cf0b1b92')
    expect(target.inputs.length).to eq(1)
    expect(target.inputs[0].txid).to eq('7e85ec5abe0af280bf338b0352b6e120a31a5b84b3ca196789610704122d68a6')
    target.outputs.each{|o| puts o.uuid}
    expect(target.outputs.length).to eq(2)

    # expect(target.outputs).to contain_exactly(have_attributes(script_pubkey_hex: '76a9142d8838af0d7786ffbfec7136837d576af982ea8b88ac'),
    #                                           have_attributes(script_pubkey_hex: '76a9141ea1b9194abd07be423d0b8d7d3b9e7028fb438288ac'))
  end

  it 'latest' do
    Graphdb::Model::Block.create_from_block_height(722039)
    Graphdb::Model::Block.create_from_block_height(721046)
    block = Graphdb::Model::Block.as(:latest_block).latest(:latest_block)
    expect(block.height).to eq(722039)
  end
end