module Graphdb
  module Model

    class AssetId < ActiveNodeBase
      property :asset_id, index: :exact, constraint: :unique

      validates :asset_id, :presence => true

      scope :with_asset_id, ->(asset_id){where(asset_id: asset_id)}

    end
  end
end