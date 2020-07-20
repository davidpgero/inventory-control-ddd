require_relative 'test_helper'

module InventoryControlling
  class TransferStockTest < ActiveSupport::TestCase
    include TestCase

    cover 'InventoryControlling::TransferStock'

    test "stock is transferred" do
      aggregate_id = SecureRandom.uuid
      stream = "InventoryControlling::Product$#{aggregate_id}"
      product = ::Product.create(uid: aggregate_id, name: "test_product")
      location = ::Location.create(name: "test_location")
      new_location = ::Location.create(name: "new_test_location")
      quantity = rand(100)

      arrange(stream, [
          StockCameIn.new(data: {product_id: aggregate_id, location_id: location.id, quantity: quantity})
      ])

      published = act(stream, TransferStock.new(product_id: aggregate_id, location_id: location.id, quantity: quantity, new_location_id: new_location.id))
      assert_changes(published, [StockTransferred.new(data: {product_id: aggregate_id, location_id: location.id, quantity: quantity, new_location_id: new_location.id})])
    end
  end
end