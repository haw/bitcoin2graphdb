require 'spec_helper'
describe Graphdb::Model::Block do

  describe 'create association node' do
    before{
      before_block = Graphdb::Model::Block.new
      before_block.block_hash = '00000000000005bc0dfe560845f069733c0b1d07a2a5044d7c01cc0568145122'
      before_block.height = 722038
      before_block.merkle_root = "merkle_root"
      before_block.version = 1
      before_block.size = 1
      before_block.time = Time.now
      before_block.nonce = 1
      before_block.save
      @block = Graphdb::Model::Block.create_from_block_height(722039)
    }
    it do
      expect(@block.transactions.length).to eq(4)
      expect(@block.transactions).to contain_exactly(
                                        have_attributes(txid: '8a750f083b2d7b5166be2ea897a073830a7e5cf7dafdb54f0a6c9151b39de60b'),
                                        have_attributes(txid: 'f1e579409e5d6ae20424f71b5cf46b8a7fd5deb62a0b3da989c33957cf0b1b92'),
                                        have_attributes(txid: 'b50ddb740dae9b2b652dfe4db84e2d594e02ca9323adf3e614e1edd8b1ea6f1e'),
                                        have_attributes(txid: 'a983a4d0326ddb177107431515832205c843a61f0bb518be459134f3bdd035db'))
      expect(@block.previous_block.height).to eq(722038)
      target = @block.transactions.find{|t|t.txid == 'f1e579409e5d6ae20424f71b5cf46b8a7fd5deb62a0b3da989c33957cf0b1b92'}
      expect(target.txid).to eq('f1e579409e5d6ae20424f71b5cf46b8a7fd5deb62a0b3da989c33957cf0b1b92')
      expect(target.inputs.length).to eq(1)
      expect(target.inputs[0].txid).to eq('7e85ec5abe0af280bf338b0352b6e120a31a5b84b3ca196789610704122d68a6')
      target.outputs.each{|o| puts o.uuid}
      expect(target.outputs.length).to eq(2)
    end
  end

  describe 'get latest block' do
    before {
      Graphdb::Model::Block.create_from_block_height(722039)
      Graphdb::Model::Block.create_from_block_height(721046)
    }
    it do
      block = Graphdb::Model::Block.latest
      expect(block.height).to eq(722039)
    end
  end

  describe 'with block hash' do
    before {
      Graphdb::Model::Block.create_from_block_height(721046)
    }
    it do
      block_hash = '00000000000036ffc3e2e3c247bab16e151be44a34207f822ffd7c7b879541cb'
      block = Graphdb::Model::Block.with_block_hash(block_hash).first
      expect(block.block_hash).to eq(block_hash)
      expect(block.height).to eq(721046)
      expect(Graphdb::Model::Block.with_block_hash('00000000000036ffc3e2e3c247bab16e151be44a34207f822ffd7c7b879541cc').first).to be nil
    end
  end

  describe 'genesis_block?' do
    before{
      @genesis_block = Graphdb::Model::Block.create_from_block_height(0)
      @non_genesis_block = Graphdb::Model::Block.create_from_block_height(721046)
    }
    it do
      expect(@genesis_block.genesis_block?).to be true
      expect(@non_genesis_block.genesis_block?).to be false
    end
  end
end