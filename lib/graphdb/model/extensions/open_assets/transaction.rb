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
              tx.apply_oa_outputs
              tx.save!
              tx
            end

          end

          # Check this tx contains open assets transaction
          def openassets_tx?
            outputs.each do |o|
              return true unless o.asset_id.nil?
            end
            false
          end

          def apply_oa_outputs
            oa_outputs = Bitcoin2Graphdb::Bitcoin.provider.oa_outputs(txid)
            if oa_outputs.any?{ |tx_out| tx_out['output_type'] == 'marker' }
              oa_outputs.each{|o|
                output = outputs.find_by(n: o['vout'])
                output.apply_oa_attributes(o)
              }
            end
          end

        end

      end
    end
  end
end