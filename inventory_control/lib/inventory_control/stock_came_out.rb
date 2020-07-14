module InventoryControl
  class StockCameOut < Event
    attribute :product_id, Types::UUID
    attribute :location_id, Types::ID
    attribute :quantity, Types::Integer
  end
end