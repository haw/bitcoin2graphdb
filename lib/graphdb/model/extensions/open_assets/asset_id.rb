module Graphdb
  module Model

    class AssetId < ActiveNodeBase
      property :asset_id, index: :exact, constraint: :unique

      validates :asset_id, :presence => true

      scope :with_asset_id, ->(asset_id){where(asset_id: asset_id)}

      def self.find_or_create(asset_id)
        a = with_asset_id(asset_id).first
        unless a
          a = new
          a.asset_id = asset_id
          a.save!
        end
        a
      end
    end
  end
end