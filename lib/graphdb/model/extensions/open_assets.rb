module Graphdb
  module Model
    module Extensions
      module OpenAssets
        autoload :OaTransaction, 'graphdb/model/extensions/open_assets/oa_transaction'

        EXTENSIONS_TARGETS = [OaTransaction]
      end
    end
  end
end