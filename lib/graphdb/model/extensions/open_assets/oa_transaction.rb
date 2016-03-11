module Graphdb
  module Model
    module Extensions
      module OpenAssets

        module OaTransaction

          extend Graphdb::Model::Extensions::Base

          def self.prepended(base)
            class << base
              self.prepend(ClassMethods)
            end
            base.class_eval do
              # asset output type (:issuance, :transfer, :uncolored)
              property :output_type
            end
          end

          module ClassMethods

            def create_from_txid(txid)
              tx = super(txid)
              outputs = Bitcoin2Graphdb::Bitcoin.provider.oa_outputs(txid)
              outputs.each do |o|
                if o['output_type'] == 'issuance'
                  tx.output_type = 'issuance'
                  break
                elsif o['output_type'] == 'transfer'
                  tx.output_type = 'transfer'
                  break
                end
              end
              tx.output_type = 'uncolored' if tx.output_type.nil?
              tx
            end
          end

          set_origin Graphdb::Model::Transaction

        end

      end
    end
  end
end