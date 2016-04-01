module Graphdb
  module Model

    autoload :AssetId, 'graphdb/model/extensions/open_assets/asset_id'

    module Extensions
      module OpenAssets
        Graphdb::Model::Extensions::OpenAssets.autoload :TxOut, 'graphdb/model/extensions/open_assets/tx_out'
        Graphdb::Model::Extensions::OpenAssets.autoload :Transaction, 'graphdb/model/extensions/open_assets/transaction'

        Graphdb::Model::Transaction.prepend(Graphdb::Model::Extensions::OpenAssets::Transaction)
        Graphdb::Model::TxOut.prepend(Graphdb::Model::Extensions::OpenAssets::TxOut)
      end
    end
  end
end