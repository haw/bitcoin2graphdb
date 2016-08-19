module Graphdb
  module Model
    class Address < ActiveNodeBase
      property :address, index: :exact

      has_many :in, :outputs, origin: :addresses, model_class: 'Graphdb::Model::TxOut'

      validates :address, presence: true

      scope :with_address, -> (address){where(address: address)}

      def self.find_or_create(address)
        a = with_address(address).first
        unless a
          a = new
          a.address = address
          a.save!
        end
        a
      end
    end
  end
end