module InventoryControlling
  class AdjustStock < Command
    attribute :product_id, Types::UUID
    attribute :location_id, Types::ID
    attribute :quantity, Types::Quantity
    attribute :new_quantity, Types::Quantity.constrained(not_eql: :quantity)

    alias :aggregate_id :product_id
  end
end