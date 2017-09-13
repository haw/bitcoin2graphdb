module Graphdb
  module Model

    class AssetId < ActiveNodeBase
      property :asset_id, index: :exact

      has_many :in, :outputs, origin: :asset_id, model_class: 'Graphdb::Model::TxOut'

      validates :asset_id, :presence => true

      scope :with_asset_id, ->(asset_id){where(asset_id: asset_id)}

      def self.find_or_create(asset_id)
        a = with_asset_id(asset_id).first
        unless a
          a = new
          a.asset_id = asset_id
          a.save!
        end
        a
      end

      # Get issuance transactions
      def issuance_txs
        outputs.select{|o|o.oa_output_type == 'issuance'}.
            map(&:transaction).uniq{|tx| tx.txid}.sort{|a,b| b.block_time <=> a.block_time}
      end

    end
  end
end