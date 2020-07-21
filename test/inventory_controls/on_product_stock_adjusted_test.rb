require 'test_helper'

module InventoryControls
  class ProductStockAdjustedTest < ActiveJob::TestCase
    test "product stock adjusted" do
      event_store = Rails.configuration.event_store

      product_id = SecureRandom.uuid
      location = ::Location.create(name: "test_location", address: "test_address")
      product = ::Product.create(uid: product_id, name: "test_product")
      quantity = 100

      event_store.publish(InventoryControlling::StockCameIn.new(data: { product_id: product_id, location_id: location.id, quantity: quantity}))
      event_store.publish(InventoryControlling::StockCameIn.new(data: { product_id: product_id, location_id: location.id, quantity: quantity}))

      assert_equal(ProductStock.count, 1)
      stock = ProductStock.find_by(product_id: product_id)
      assert_equal(stock.quantity, quantity * 2)

      last_quantity = 20
      quantities = [50, 150, 20]
      new_qty = quantity
      quantities.each do |qty|
        event_store.publish(InventoryControlling::StockAdjusted.new(data: { product_id: product_id, location_id: location.id, quantity: new_qty, new_quantity: qty}))
        new_qty = qty
      end

      assert_equal(ProductStock.count, 1)
      stock = ProductStock.find_by(product_id: product_id)
      assert_equal(stock.quantity, quantity + last_quantity)
    end
  end
end