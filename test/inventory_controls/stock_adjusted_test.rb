require 'test_helper'

module InventoryControls
  class StockAdjustedTest < ActiveJob::TestCase
    test 'stock adjusted' do
      event_store = Rails.configuration.event_store

      product_id = SecureRandom.uuid
      location = ::Location.create(name: "test_location", address: "test_address")
      product = ::Product.create(uid: product_id, name: "test_product")
      quantity = rand(1..10)
      new_quantity = rand(11..100)

      event_store.publish(InventoryControlling::StockCameIn.new(data: { product_id: product_id, location_id: location.id, quantity: quantity}))

      event_store.publish(InventoryControlling::StockAdjusted.new(data: { product_id: product_id, location_id: location.id, quantity: quantity, new_quantity: new_quantity}))

      assert_equal(Stock.count, 1)
      stock = Stock.find_by(product_id: product_id)
      assert_equal(stock.quantity, new_quantity)
    end
  end
end