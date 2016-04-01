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
              outputs.each{|o|tx.outputs[o['vout']].apply_oa_attributes(o)}
              tx.save!
              tx
            end

          end

        end

      end
    end
  end
end