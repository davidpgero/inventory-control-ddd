module InventoryControlling
  class TransferStock < Command
    attribute :product_id, Types::UUID
    attribute :location_id, Types::ID
    attribute :new_location_id, Types::ID.constrained(not_eql: :location_id)
    attribute :quantity, Types::Quantity

    alias :aggregate_id :product_id
  end
end