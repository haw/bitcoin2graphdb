module Graphdb
  module Model
    class Transaction < ActiveNodeBase

      property :hex
      property :txid, index: :exact, constraint: :unique
      property :version, type: Integer
      property :lock_time
      property :block_hash
      property :block_time, type: Time
      property :time, type: Time
      property :confirmations, type: Integer

      has_one :out, :block, type: :block
      has_many :in, :inputs, origin: :tx
      has_many :in, :outputs, origin: :tx

      def self.from_txid(txid)
        tx = new
        hash = Bitcoin2Graphdb::Bitcoin.provider.tx(txid)
        tx.hex = hash['hex']
        tx.txid = hash['txid']
        tx.version = hash['version']
        tx.block_time = hash['blocktime']
        tx.lock_time = hash['locktime']
        tx.block_hash = hash['blockhash']
        tx.time = hash['time']
        tx.confirmations = hash['confirmations']
        tx
      end

    end
  end
end