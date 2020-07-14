require_relative 'test_helper'

module InventoryControlling
  class TransferStockTest < ActiveSupport::TestCase
    include TestCase

    cover 'InventoryControlling::TransferStock'

    test "stock is came out" do
      location = InventoryControls::Location.create(name: "test_location")
      new_location = InventoryControls::Location.create(name: "new_test_location")
      aggregate_id = SecureRandom.uuid
      quantity = rand(100)


      stream = "InventoryControlling::Product$#{aggregate_id}"
      published = act(stream, TransferStock.new(product_id: aggregate_id, location_id: location.id, quantity: quantity, new_location_id: new_location.id))
      assert_changes(published, [StockTransferred.new(data: {product_id: aggregate_id, location_id: location.id, quantity: quantity, new_location_id: new_location.id})])
    end
  end
end