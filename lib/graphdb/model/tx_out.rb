module Graphdb
  module Model
    class TxOut < ActiveNodeBase

      property :value
      property :n, type: Integer
      property :script_pubkey_asm
      property :script_pubkey_hex
      property :output_type
      property :req_sigs, type: Integer

      has_one :out, :transaction, type: :transaction, model_class: Transaction

      validates :value, :presence => true
      validates :n, :presence => true
      validates :script_pubkey_asm, :presence => true
      validates :script_pubkey_hex, :presence => true

      def self.create_from_hash(hash)
        tx_out = new
        tx_out.value = hash['value']
        tx_out.n = hash['n']
        if hash['scriptPubKey']
          tx_out.script_pubkey_asm = hash['scriptPubKey']['asm']
          tx_out.script_pubkey_hex = hash['scriptPubKey']['hex']
          tx_out.output_type = hash['scriptPubKey']['type']
          tx_out.req_sigs = hash['scriptPubKey']['reqSigs']
        end
        tx_out.save!
        tx_out
      end

    end
  end
end