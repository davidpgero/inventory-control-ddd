require_relative 'test_helper'

module InventoryControlling
  class ComeInStockTest < ActiveSupport::TestCase
    include TestCase

    cover 'InventoryControlling::ComeInStock'

    test "stock is came in" do
      location = ::Location.create(name: "test_location", address: "test_address")
      aggregate_id = SecureRandom.uuid
      product = ::Product.create(uid: aggregate_id, name: "test_product")
      quantity = rand(1..100)


      stream = "InventoryControlling::Product$#{aggregate_id}"
      published = act(stream, ComeInStock.new(product_id: aggregate_id, location_id: location.id, quantity: quantity))
      assert_changes(published, [StockCameIn.new(data: {product_id: aggregate_id, location_id: location.id, quantity: quantity})])
    end
  end
end