module Bitcoin2Graphdb
  module Graphdb
    class TxIn
      include Neo4j::ActiveNode

      property :txid
      property :vout, type: Integer
      property :script_sig_asm
      property :script_sig_hex
      property :coinbase
      property :sequence

      has_one :out, :tx, type: :tx
    end
  end
end