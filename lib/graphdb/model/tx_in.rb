module Graphdb
  module Model
    class TxIn
      include Neo4j::ActiveNode

      property :txid
      property :vout, type: Integer
      property :script_sig_asm
      property :script_sig_hex
      property :coinbase
      property :sequence

      has_one :out, :tx, type: :tx

      def self.from_hash(hash)
        tx_in = new
        tx_in.txid = hash['txid']
        tx_in.vout = hash['vout']
        if hash['scriptSig']
          tx_in.script_sig_asm = hash['scriptSig']['asm']
          tx_in.script_sig_hex = hash['scriptSig']['hex']
        end
        tx_in.coinbase = hash['coinbase']
        tx_in.sequence = hash['sequence']
        tx_in
      end

    end
  end
end