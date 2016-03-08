require 'spec_helper'

describe Graphdb::Model::Transaction do

  describe 'create tx node' do
    subject {
      Graphdb::Model::Transaction.create_from_txid('f0315ffc38709d70ad5647e22048358dd3745f3ce3874223c80a7c92fab0c8ba')
    }
    it do
      expect(subject.hex).to eq('01000000010000000000000000000000000000000000000000000000000000000000000000ffffffff0e0420e7494d017f062f503253482fffffffff0100f2052a010000002321021aeaf2f8638a129a3156fbe7e5ef635226b0bafd495ff03afe2c843d7e3a4b51ac00000000')
      expect(subject.txid).to eq('f0315ffc38709d70ad5647e22048358dd3745f3ce3874223c80a7c92fab0c8ba')
      expect(subject.version).to eq(1)
      expect(subject.lock_time).to eq(0)
      expect(subject.block_hash).to eq('00000000b873e79784647a6c82962c70d228557d24a747ea4d1b8bbe878e1206')
      expect(subject.block_time).to eq(Time.at(1296688928))
      expect(subject.time).to eq(Time.at(1296688928))
      expect(subject.confirmations).to eq(721325)
    end
  end

  describe 'scope' do
    describe 'txid' do
      before{
        Graphdb::Model::Transaction.create_from_txid('8a750f083b2d7b5166be2ea897a073830a7e5cf7dafdb54f0a6c9151b39de60b')
        Graphdb::Model::Transaction.create_from_txid('05587f30d146126f5d81ff17c24177645669df3d75f69b50ae21d24e5ef162e3')
      }
      subject {
        Graphdb::Model::Transaction.with_txid('05587f30d146126f5d81ff17c24177645669df3d75f69b50ae21d24e5ef162e3').first
      }
      it do
        expect(subject.txid).to eq('05587f30d146126f5d81ff17c24177645669df3d75f69b50ae21d24e5ef162e3')
        expect(subject.outputs.length).to eq(2)
      end
    end
  end
  
end