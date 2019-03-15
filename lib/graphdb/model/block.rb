module Graphdb
  module Model
    class Block < ActiveNodeBase

      property :block_hash
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
      property :confirmations, type: Integer
      property :created_at
      property :updated_at

      has_many :in, :transactions, origin: :block, model_class: 'Graphdb::Model::Transaction', dependent: :destroy
      has_one :out, :previous_block, type: :previous_block, model_class: 'Graphdb::Model::Block'

      validates :block_hash, :presence => true
      validates :height, :presence => true
      validates :merkle_root, :presence => true
      validates :version, :presence => true
      validates :size, :presence => true
      validates :time, :presence => true
      validates :nonce, :presence => true

      after_create :chain_previous_block

      scope :latest, -> {order(height: 'DESC')}
      scope :with_block_hash, -> (block_hash){where(block_hash: block_hash)}
      scope :with_height, -> (height){where(height: height)}

      def self.create_from_block_height(block_height)
        block = new
        block.block_hash = Bitcoin2Graphdb::Bitcoin.provider.block_hash(block_height)
        hash = Bitcoin2Graphdb::Bitcoin.provider.block(block.block_hash)
        block.size = hash['size']
        block.height = hash['height']
        block.version = hash['version']
        block.merkle_root = hash['merkleroot']
        block.time = Time.at(hash['time'])
        block.nonce = hash['nonce']
        block.bits = hash['bits']
        block.difficulty = hash['difficulty']
        block.chain_work = hash['chainwork']
        block.previous_block_hash = hash['previousblockhash']
        # check previous block exist?
        begin
          Bitcoin2Graphdb::Bitcoin.provider.block(block.previous_block_hash) if block.previous_block_hash # except genesis block
        rescue OpenAssets::Provider::ApiError
          raise Bitcoin2Graphdb::Error, 'previous block not found. maybe re-org occured.'
        end
        block.next_block_hash = hash['nextblockhash']
        block.confirmations = hash['confirmations']
        block.save!
        unless block.genesis_block?
          hash['tx'].each do |txid|
            block.transactions << Graphdb::Model::Transaction.create_from_txid(txid)
          end
        end
        block.save!
        block
      end

      def genesis_block?
        Bitcoin.network[:genesis_hash] == block_hash
      end

      private

      def chain_previous_block
        unless self.previous_block_hash.nil?
          self.previous_block = Block.with_block_hash(self.previous_block_hash).first
          save!
        end
      end

    end
  end
end