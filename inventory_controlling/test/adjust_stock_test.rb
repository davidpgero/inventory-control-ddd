require_relative 'test_helper'

module InventoryControlling
  class AdjustStockTest < ActiveSupport::TestCase
    include TestCase

    cover 'InventoryControlling::AdjustStock'

    test "stock is came out" do
      location = InventoryControls::Location.create(name: "test_location")
      aggregate_id = SecureRandom.uuid
      quantity = rand(100)
      new_quantity = rand(100)


      stream = "InventoryControlling::Product$#{aggregate_id}"
      published = act(stream, AdjustStock.new(product_id: aggregate_id, location_id: location.id, quantity: quantity, new_quantity: new_quantity))
      assert_changes(published, [StockAdjusted.new(data: {product_id: aggregate_id, location_id: location.id, quantity: quantity, new_quantity: new_quantity})])
    end
  end
end