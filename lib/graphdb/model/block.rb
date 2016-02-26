module Graphdb
  module Model
    class Block
      include Neo4j::ActiveNode

      property :block_hash, index: :exact, constraint: :unique
      property :size, type: Integer
      property :height, type: Integer
      property :version
      property :merkle_root
      property :time, type: Time
      property :nonce, type: Integer
      property :bits
      property :difficulty
      property :chain_work
      property :previous_block_hash
      property :next_block_hash

      has_many :in, :txes, origin: :block

      def initialize(block_height)
        self.block_hash = Bitcoin2Graphdb::Bitcoin.provider.block_hash(block_height)
        block = Bitcoin2Graphdb::Bitcoin.provider.block(block_hash)
        self.size = block['size']
        self.height = block['height']
        self.version = block['version']
        self.merkle_root = block['merkleroot']
        self.time = Time.at(block['time'])
        self.nonce = block['nonce']
        self.bits = block['bits']
        self.difficulty = block['difficulty']
        self.chain_work = block['chainwork']
        self.previous_block_hash = block['previouseblockhash']
        self.next_block_hash = block['nextblockhash']
      end

    end
  end
end