module InventoryControlling
  class Stock
    attr_reader :product_id, :location_id, :quantity

    # todo, it's a value object...
    attr_accessor :state

    def initialize(product_id, location_id, quantity, state = :new)
      @product_id = product_id
      @location_id = location_id
      @quantity = quantity
      @state = state
    end
  end
end