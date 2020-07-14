module InventoryControlling
  class AdjustStock < Command
    attribute :product_id, Types::UUID
    attribute :location_id, Types::ID
    attribute :quantity, Types::Integer
    attribute :new_quantity, Types::Integer

    alias :aggregate_id :product_id
  end
end