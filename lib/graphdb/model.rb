module Graphdb
  module Model
    autoload :Database, 'graphdb/model/database'
    autoload :Block, 'graphdb/model/block'
    autoload :Transaction, 'graphdb/model/transaction'
    autoload :TxIn, 'graphdb/model/tx_in'
    autoload :TxOut, 'graphdb/model/tx_out'
  end
end