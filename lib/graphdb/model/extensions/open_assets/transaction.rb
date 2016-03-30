module Graphdb
  module Model
    module Extensions
      module OpenAssets

        module Transaction

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
              tx.output_type = output_type(txid)
              tx.save!
              tx
            end

            private
            def output_type(txid)
              outputs = Bitcoin2Graphdb::Bitcoin.provider.oa_outputs(txid)
              output_type = 'uncolored'
              outputs.each do |o|
                if o['output_type'] == 'issuance'
                  output_type = 'issuance'
                  break
                elsif o['output_type'] == 'transfer'
                  output_type = 'transfer'
                  break
                end
              end
              output_type
            end
          end

        end

      end
    end
  end
end