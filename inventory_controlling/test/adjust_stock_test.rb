require_relative 'test_helper'

module InventoryControlling
  class AdjustStockTest < ActiveSupport::TestCase
    include TestCase

    cover 'InventoryControlling::AdjustStock'

    test "stock is adjusted" do
      aggregate_id = SecureRandom.uuid
      stream = "InventoryControlling::Product$#{aggregate_id}"
      product = ::Product.create(uid: aggregate_id, name: "test_product")
      location = ::Location.create(name: "test_location")
      location_id = location.id
      quantity = rand(1..20)
      new_quantity = rand(21..100)

      arrange(stream, [
          StockCameIn.new(data: {product_id: aggregate_id, location_id: location_id, quantity: quantity})
      ])

      cmd = AdjustStock.call(product_id: aggregate_id, location_id: location_id, quantity: quantity, new_quantity: new_quantity)
      published = act(stream, cmd)
      assert_changes(published, [StockAdjusted.new(data: {product_id: aggregate_id, location_id: location_id, quantity: quantity, new_quantity: new_quantity})])
    end
  end
end