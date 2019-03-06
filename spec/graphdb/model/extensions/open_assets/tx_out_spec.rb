require 'spec_helper'

describe 'Graphdb::Model::Extensions::OpenAssets::TxOut' do

  describe 'output coloring' do
    before{
      Graphdb::Model::Transaction.create_from_txid('525f7baa656d04016fad0094187cc969b526ca1261312ddf09a648d822ee6cdd')
      Graphdb::Model::Transaction.create_from_txid('2ef6aaf051229ff755a137a51466b54da6d8c87d17130bca8a879e9e64172ebd')
      Graphdb::Model::Transaction.create_from_txid('9efbf61ef4805708ecf8e31d982ab6de20b2d131ed9be00d2856a5fe5a8b3df5')
    }
    it do
      txid = '2ef6aaf051229ff755a137a51466b54da6d8c87d17130bca8a879e9e64172ebd'
      o0 = Graphdb::Model::TxOut.find_by_outpoint(txid, 0)
      o1 = Graphdb::Model::TxOut.find_by_outpoint(txid, 1)
      o2 = Graphdb::Model::TxOut.find_by_outpoint(txid, 2)
      o3 = Graphdb::Model::TxOut.find_by_outpoint(txid, 3)
      expect(o0.n).to eq(0)
      expect(o0.oa_output_type).to eq('marker')
      expect(o1.n).to eq(1)
      expect(o1.oa_output_type).to eq('transfer')
      expect(o2.n).to eq(2)
      expect(o2.oa_output_type).to eq('transfer')
      expect(o3.n).to eq(3)
      expect(o3.oa_output_type).to eq('uncolored')
    end
  end

end