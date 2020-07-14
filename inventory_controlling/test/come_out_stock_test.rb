require_relative 'test_helper'

module InventoryControlling
  class ComeOutStockTest < ActiveSupport::TestCase
    include TestCase

    cover 'InventoryControlling::ComeOutStock'

    test "stock is came out" do
      location = InventoryControls::Location.create(name: "test_location")
      aggregate_id = SecureRandom.uuid
      quantity = rand(100)


      stream = "InventoryControlling::Product$#{aggregate_id}"
      published = act(stream, ComeOutStock.new(product_id: aggregate_id, location_id: location.id, quantity: quantity))
      assert_changes(published, [StockCameOut.new(data: {product_id: aggregate_id, location_id: location.id, quantity: quantity})])
    end
  end
end