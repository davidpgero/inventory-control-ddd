module InventoryControlling
  class Stock
    attr_reader :product_id, :location_id, :quantity

    def initialize(product_id, location_id, quantity)
      @product_id = product_id
      @location_id = location_id
      @quantity = quantity
    end
  end
end