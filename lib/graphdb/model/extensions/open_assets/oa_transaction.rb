module Graphdb
  module Model
    module Extensions
      module OpenAssets

        module OaTransaction

          extend Graphdb::Model::Extensions::Base

          def self.included(base)
            base.class_eval do
              # asset output type (:issuance, :transfer, :uncolored)
              property :output_type
            end
          end

          set_origin Graphdb::Model::Transaction

        end

      end
    end
  end
end