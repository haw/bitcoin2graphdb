require 'spec_helper'
require 'graphdb/model/extensions/open_assets/asset_id'
describe Graphdb::Model::AssetId do

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

end