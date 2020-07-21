require 'test_helper'

module InventoryControls
  class ProductStockCameInTest < ActiveJob::TestCase
    test "product stock come in" do
      event_store = Rails.configuration.event_store

      product_id = SecureRandom.uuid
      location = ::Location.create(name: "test_location", address: "test_address")
      product = ::Product.create(uid: product_id, name: "test_product")
      quantity = rand(100)

      event_store.publish(InventoryControlling::StockCameIn.new(data: { product_id: product_id, location_id: location.id, quantity: quantity}))

      assert_equal(ProductStock.count, 1)
      stock = ProductStock.find_by(product_id: product_id)
      assert_equal(stock.quantity, quantity)

      event_store.publish(InventoryControlling::StockCameIn.new(data: { product_id: product_id, location_id: location.id, quantity: quantity}))

      assert_equal(ProductStock.count, 1)
      stock = ProductStock.find_by(product_id: product_id)
      assert_equal(stock.quantity, quantity * 2)
    end
  end
end