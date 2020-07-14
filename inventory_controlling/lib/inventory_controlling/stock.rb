module InventoryControlling
  class Stock
    include Comparable
    attr_reader :product_id

    def initialize(product_id, location_id, quantity)
      @product_id = product_id
      @location_id = location_id
      @quantity = quantity
    end

    def increase_quantity(quantity = 1)
      @quantity += quantity
    end

    def decrease_quantity(quantity = -1)
      @quantity -= quantity
    end

    def empty?
      @quantity == 0
    end

    def <=>(other)
      self.product_id <=> other.product_id
    end

    private

    attr_accessor :quantity
  end
end