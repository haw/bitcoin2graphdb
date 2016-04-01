module Graphdb
  module Model
    module Extensions
      module OpenAssets

        module Transaction

          def self.prepended(base)
            class << base
              self.prepend(ClassMethods)
            end
          end

          module ClassMethods

            def create_from_txid(txid)
              tx = super(txid)
              outputs = Bitcoin2Graphdb::Bitcoin.provider.oa_outputs(txid)
              outputs.each do |o|
                tx_out = tx.outputs[o['vout']]
                tx_out.asset_quantity = o['asset_quantity']
                unless o['asset_id'].nil?
                  asset_id = AssetId.find_or_create(o['asset_id'])
                  tx_out.asset_id = asset_id
                end
                tx_out.save!
              end
              tx.save!
              tx
            end

          end

        end

      end
    end
  end
end