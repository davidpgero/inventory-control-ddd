require_relative 'test_helper'

module InventoryControlling
  class ComeOutStockTest < ActiveSupport::TestCase
    include TestCase

    cover 'InventoryControlling::ComeOutStock'

    test "stock is came out" do
      aggregate_id = SecureRandom.uuid
      stream = "InventoryControlling::Product$#{aggregate_id}"
      product = ::Product.create(uid: aggregate_id, name: "test_product")
      quantity = rand(100)
      location = ::Location.create(name: "test_location")

      arrange(stream, [
          StockCameIn.new(data: {product_id: aggregate_id, location_id: location.id, quantity: quantity})
      ])

      cmd = ComeOutStock.new(product_id: aggregate_id, location_id: location.id, quantity: quantity)
      published = act(stream, cmd)
      assert_changes(published, [StockCameOut.new(data: {product_id: aggregate_id, location_id: location.id, quantity: quantity})])
    end
  end
end