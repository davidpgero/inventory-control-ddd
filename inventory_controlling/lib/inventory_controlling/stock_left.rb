module InventoryControlling
  class StockLeft < Event
    attribute :product_id, Types::UUID
    attribute :location_id, Types::ID
    attribute :quantity, Types::Quantity

    alias :aggregate_id :product_id
  end
end