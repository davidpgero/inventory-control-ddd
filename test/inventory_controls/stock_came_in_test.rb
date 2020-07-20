require 'test_helper'

module InventoryControls
  class StockCameInTest < ActiveJob::TestCase
    test "stock come in" do
      event_store = Rails.configuration.event_store

      product_id = SecureRandom.uuid
      location = ::Location.create(name: "test_location", address: "test_address")
      product = ::Product.create(uid: product_id, name: "test_product")
      quantity = rand(100)

      event_store.publish(InventoryControlling::StockCameIn.new(data: { product_id: product_id, location_id: location.id, quantity: quantity}))

      assert_equal(Stock.count, 1)
      stock = Stock.find_by(product_id: product_id)
      assert_equal(stock.product_id, product_id)
      assert_equal(stock.quantity, quantity)
      assert_equal(stock.location_id, location.id)
      assert_equal(stock.product_name, product.name)
      assert_equal(stock.location_name, location.name)
      assert_equal(stock.location_address, location.address)
    end
  end
end