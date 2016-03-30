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
              # has_one :out, :asset_id, type: :asset_id
            end
          end

          module ClassMethods

          end

        end
      end
    end
  end
end