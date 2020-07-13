module InventoryControl
  class StockCameOut < Event
    attribute :product_id, Types::UUID
  end
end