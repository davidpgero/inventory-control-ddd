module InventoryControlling
  class AdditionalStockReserved < Event
    attribute :product_id, Types::UUID
    attribute :quantity, Types::Quantity

    alias :aggregate_id :product_id
  end
end