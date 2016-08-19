module Graphdb
  module Model
    class Transaction < ActiveNodeBase

      property :hex
      property :txid, index: :exact
      property :version, type: Integer
      property :lock_time
      property :block_hash
      property :block_time, type: Time
      property :time, type: Time
      property :confirmations, type: Integer

      has_one :out, :block, type: :block
      has_many :in, :inputs, origin: :transaction, model_class: 'Graphdb::Model::TxIn', dependent: :destroy
      has_many :in, :outputs, origin: :transaction, model_class: 'Graphdb::Model::TxOut', dependent: :destroy

      validates :hex, :presence => true
      validates :txid, :presence => true
      validates :version, :presence => true
      validates :block_hash, :presence => true

      scope :with_txid, ->(txid){where(txid: txid)}

      def self.create_from_txid(txid)
        puts "create tx #{txid}. #{Time.now}"
        tx = new
        hash = load_tx(txid)
        tx.hex = hash['hex']
        tx.txid = hash['txid']
        tx.version = hash['version']
        tx.block_time = hash['blocktime']
        tx.lock_time = hash['locktime']
        tx.block_hash = hash['blockhash']
        tx.time = hash['time']
        tx.confirmations = hash['confirmations']
        tx.save!
        hash['vin'].each do |i|
          tx.inputs << Graphdb::Model::TxIn.create_from_hash(i)
        end
        hash['vout'].each do |o|
          tx.outputs << Graphdb::Model::TxOut.create_from_hash(o)
        end
        tx.save!
        tx
      end

      private
      def self.load_tx(txid)
        Bitcoin2Graphdb::Bitcoin.provider.tx(txid)
      end

    end
  end
end