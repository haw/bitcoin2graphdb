module Bitcoin2Graphdb
  module Graphdb
    autoload :Database, 'bitcoin2graphdb/graphdb/database'
    autoload :Block, 'bitcoin2graphdb/graphdb/block'
    autoload :Tx, 'bitcoin2graphdb/graphdb/tx'
    autoload :TxIn, 'bitcoin2graphdb/graphdb/tx_in'
    autoload :TxOut, 'bitcoin2graphdb/graphdb/tx_out'
  end
end