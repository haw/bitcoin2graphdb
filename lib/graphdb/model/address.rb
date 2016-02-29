module Graphdb
  module Model
    class Address < ActiveNodeBase
      property :address, index: :exact, constraint: :unique

      validates :address, presence: true

      scope :with_address, -> (address){where(address: address).first}

      def self.find_or_create(address)
        a = with_address(address)
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