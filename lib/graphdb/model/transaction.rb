module Graphdb
  module Model
    class Transaction
      include Neo4j::ActiveNode
      property :hex
      property :txid, index: :exact, constraint: :unique
      property :version, type: Integer
      property :lock_time
      property :block_hash
      property :block_time, type: Time
      property :time, type: Time

      has_one :out, :block, type: :block
      has_many :in, :inputs, origin: :tx
      has_many :in, :outputs, origin: :tx

      def initialize(txid)
        tx = Bitcoin2Graphdb::Bitcoin.provider.tx(txid)
        self.hex = tx['hex']
        self.txid = tx['txid']
        self.version = tx['version']
        self.block_time = tx['blocktime']
        self.lock_time = tx['locktime']
        self.block_hash = tx['blockhash']
        self.time = tx['time']
      end

    end
  end
end