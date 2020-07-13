module InventoryControl
  class StockTransferred < Event
    attribute :product_id, Types::UUID
    attribute :location_id, Types::UUID
    attribute :new_location_id, Types::UUID

    alias :aggregate_id :product_id
  end
end