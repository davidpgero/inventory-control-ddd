require_relative 'test_helper'

module InventoryControlling
  class ComeInStockTest < ActiveSupport::TestCase
    include TestCase

    cover 'InventoryControlling::ComeInStock'

    test "stock is came in" do
      location = InventoryControls::Location.create(name: "test_location")
      aggregate_id = SecureRandom.uuid
      quantity = rand(100)


      stream = "InventoryControlling::Product$#{aggregate_id}"
      published = act(stream, ComeInStock.new(product_id: aggregate_id, location_id: location.id, quantity: quantity))
      assert_changes(published, [StockCameIn.new(data: {product_id: aggregate_id, location_id: location.id, quantity: quantity})])
    end
  end
end