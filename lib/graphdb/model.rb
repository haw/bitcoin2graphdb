module Graphdb
  module Model
    autoload :ActiveNodeBase, 'graphdb/model/active_node_base'
    autoload :Block, 'graphdb/model/block'
    autoload :Transaction, 'graphdb/model/transaction'
    autoload :TxIn, 'graphdb/model/tx_in'
    autoload :TxOut, 'graphdb/model/tx_out'
    autoload :Address, 'graphdb/model/address'
  end
end