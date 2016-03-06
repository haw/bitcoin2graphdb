module Graphdb
  module Model
    class TxIn < ActiveNodeBase

      property :txid
      property :vout, type: Integer
      property :script_sig_asm
      property :script_sig_hex
      property :coinbase
      property :sequence

      has_one :out, :transaction, type: :transaction, model_class: Transaction
      has_one :in, :TxOut, origin: :tx_out, model_class: TxOut

      validates :sequence, :presence => true

      def self.create_from_hash(hash)
        tx_in = new
        tx_in.txid = hash['txid']
        tx_in.vout = hash['vout']
        if hash['scriptSig']
          tx_in.script_sig_asm = hash['scriptSig']['asm']
          tx_in.script_sig_hex = hash['scriptSig']['hex']
        end
        tx_in.coinbase = hash['coinbase']
        tx_in.sequence = hash['sequence']
        tx_in.save!
        tx_in
      end

    end
  end
end