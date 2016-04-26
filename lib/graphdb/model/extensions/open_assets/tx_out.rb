module Graphdb
  module Model
    module Extensions
      module OpenAssets
        module TxOut

          def self.prepended(base)
            class << base
              self.prepend(ClassMethods)

            end
            base.class_eval do
              property :asset_quantity, type: Integer
              property :oa_output_type
              has_one :out, :asset_id, type: :asset_id, model_class: AssetId
            end
          end

          module ClassMethods

          end

          def apply_oa_attributes(oa_out)
            self.asset_quantity = oa_out['asset_quantity']
            self.oa_output_type = oa_out['output_type']
            self.asset_id = AssetId.find_or_create(oa_out['asset_id']) unless oa_out['asset_id'].nil?
            self.oa_output_type = 'uncolored' if self.asset_id.nil? && self.oa_output_type != 'marker'
            save!
          end

        end
      end
    end
  end
end