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
    end
  end
end