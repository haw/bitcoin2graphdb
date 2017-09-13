require 'spec_helper'
require 'graphdb/model/extensions/open_assets/asset_id'
describe Graphdb::Model::AssetId do

  before{
    Graphdb::Model::Transaction.prepend(Graphdb::Model::Extensions::OpenAssets::Transaction)
    Graphdb::Model::TxOut.prepend(Graphdb::Model::Extensions::OpenAssets::TxOut)
  }

  describe 'with asset_id scope' do
    before {
      asset = Graphdb::Model::AssetId.new
      asset.asset_id = 'hogehoge'
      asset.save!
    }
    it do
      expect(Graphdb::Model::AssetId.with_asset_id('hogehoge').first.asset_id).to eq('hogehoge')
      expect(Graphdb::Model::AssetId.with_asset_id('hoge').first).to be nil
    end
  end

  describe 'issuance transactions' do
    context 'specify one asset' do
      before{
        Graphdb::Model::Transaction.create_from_txid('666c3d92bef46695fcaf9f565509063b82c5332178ba765f4e5f8c304d5993f7')
        Graphdb::Model::Transaction.create_from_txid('fda58ba15673394731c8ca4d17e414d25d122283439e8219a6cee6435fecddf9')
        Graphdb::Model::Transaction.create_from_txid('8b226c4147b935362c57cf5a097746270bce22e0b06dc2f7ace996292e7d6c41')
      }
      subject{
        Graphdb::Model::AssetId.with_asset_id('oZQfxXhX8hKaLJ815swaA7442x9DjM4xWy').first.issuance_txs
      }
      it do
        expect(subject.length).to eq(1)
        expect(subject[0].txid).to eq('fda58ba15673394731c8ca4d17e414d25d122283439e8219a6cee6435fecddf9')
      end
    end

    context 'issuance tx has multiple outputs' do
      before {
        Graphdb::Model::Transaction.create_from_txid('ff9f231f0a582639ea73bebaf60fd9f08762201ff9760f02ae35042a85e1b298')
      }
      subject {
        Graphdb::Model::AssetId.with_asset_id('oRBG8U7j59cKN2ujnBXJWVdZZXv74w5Cf3').first.issuance_txs
      }
      it 'should be one issuance tx.' do
        expect(subject.length).to eq(1)
      end
    end
  end

end