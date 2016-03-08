require 'spec_helper'

describe Graphdb::Model::TxOut do

  describe 'create txout node' do
    subject{
      hash = {
          'value' => 0.00350000, 'n' => 0,
          'scriptPubKey' => {
              'asm' => 'OP_HASH160 50f8a391e9234d8aadc340f00ab9404b231dd742 OP_EQUAL',
              'hex' => 'a91450f8a391e9234d8aadc340f00ab9404b231dd74287',
              'reqSigs' => 1,
              'type' => 'scripthash',
              'addresses' => ['2MzdMuNFP3gUpg4dZRFYc5KJhBPTa7mCsnm']
          }
      }
      Graphdb::Model::TxOut.create_from_hash(hash)
    }
    it do
      expect(subject.value).to eq(0.00350000)
      expect(subject.n).to eq(0)
      expect(subject.script_pubkey_asm).to eq('OP_HASH160 50f8a391e9234d8aadc340f00ab9404b231dd742 OP_EQUAL')
      expect(subject.script_pubkey_hex).to eq('a91450f8a391e9234d8aadc340f00ab9404b231dd74287')
      expect(subject.req_sigs).to eq(1)
      expect(subject.output_type).to eq('scripthash')
      expect(subject.addresses.length).to eq(1)
    end
  end

  describe 'find_by_outpoint' do
    before{
      Graphdb::Model::Transaction.create_from_txid('8a750f083b2d7b5166be2ea897a073830a7e5cf7dafdb54f0a6c9151b39de60b')
      Graphdb::Model::Transaction.create_from_txid('05587f30d146126f5d81ff17c24177645669df3d75f69b50ae21d24e5ef162e3')
    }
    subject {
      Graphdb::Model::TxOut.find_by_outpoint('05587f30d146126f5d81ff17c24177645669df3d75f69b50ae21d24e5ef162e3', 1)
    }
    it do
      expect(subject.n).to eq(1)
      expect(subject.value).to eq(0.02037)
      expect(subject.value).to eq(0.02037000)
      expect(subject.script_pubkey_asm).to eq('OP_DUP OP_HASH160 4592cc94d60571949b834708505d0095ec07d2f5 OP_EQUALVERIFY OP_CHECKSIG')
    end
  end
end