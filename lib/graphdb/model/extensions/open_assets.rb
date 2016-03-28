module Graphdb
  module Model
    module Extensions
      module OpenAssets
        autoload :AssetId, 'graphdb/model/extensions/open_assets/asset_id'
        autoload :Transaction, 'graphdb/model/extensions/open_assets/transaction'

        EXTENSIONS_TARGETS = [Transaction]
      end
    end
  end
end