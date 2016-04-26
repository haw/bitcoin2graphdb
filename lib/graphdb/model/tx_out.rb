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
      has_many :out, :addresses, type: :address, model_class: Address
      has_one :out, :out_point, type: :spent_input, model_class: TxIn

      validates :value, :presence => true
      validates :n, :presence => true

      scope :with_out_index, -> (n){where(n: n)}

      def self.create_from_hash(hash)
        puts "create tx_out #{Time.now}"
        tx_out = new
        tx_out.value = hash['value']
        tx_out.n = hash['n']
        tx_out.save!
        if hash['scriptPubKey']
          tx_out.script_pubkey_asm = hash['scriptPubKey']['asm']
          tx_out.script_pubkey_hex = hash['scriptPubKey']['hex']
          tx_out.output_type = hash['scriptPubKey']['type']
          tx_out.req_sigs = hash['scriptPubKey']['reqSigs']
          if hash['scriptPubKey']['addresses']
            hash['scriptPubKey']['addresses'].each do |a|
              tx_out.addresses << Address.find_or_create(a)
            end
          end
        end
        tx_out.save!
        tx_out
      end

      def self.find_by_outpoint(txid, n)
        tx = Graphdb::Model::Transaction.with_txid(txid).first
        if tx
          tx.outputs.each{|o|
            return o if o.n == n
          }
        end
      end

    end
  end
end