module Bitcoin2Graphdb
  module Graphdb
    class TxOut
      include Neo4j::ActiveNode

      property :value
      property :vout, type: Integer
      property :script_pubkey_asm
      property :script_pubkey_hex
      property :output_type
      property :req_sig, type: Integer

      has_one :out, :tx, type: :tx
    end
  end
end