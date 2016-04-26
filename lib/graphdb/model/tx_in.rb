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
      has_one :in, :out_point, origin: :out_point, model_class: Graphdb::Model::TxOut

      validates :sequence, :presence => true

      after_create :add_out_point_rel

      def self.create_from_hash(hash)
        puts "create tx_in #{Time.now}"
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

      private
      def add_out_point_rel
        tx_out = Graphdb::Model::TxOut.find_by_outpoint(self.txid, self.vout)
        if tx_out
          self.out_point = tx_out
          save!
        end
      end

    end
  end
end