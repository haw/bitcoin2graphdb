module Graphdb
  module Model

    class AssetId < ActiveNodeBase
      property :asset_id, index: :exact, constraint: :unique

      validates :asset_id, :presence => true

    end
  end
end