require 'test_helper'

module InventoryControls
  class StockAdjustedTest < ActiveJob::TestCase
    test 'stock adjusted' do
      event_store = Rails.configuration.event_store

      location = InventoryControls::Location.create(name: "test_location")
      product_id = SecureRandom.uuid
      quantity = rand(100)
      new_quantity = rand(100)

      Stock.create(product_id: product_id, quantity: quantity, location_id: location.id)

      event_store.publish(InventoryControlling::StockAdjusted.new(data: { product_id: product_id, location_id: location.id, quantity: quantity, new_quantity: new_quantity}))

      assert_equal(Stock.count, 1)
      stock = Stock.find_by(product_id: product_id)
      assert_equal(stock.quantity, new_quantity)
    end

    test "stock adjusted when there is not match" do
      event_store = Rails.configuration.event_store

      location = InventoryControls::Location.create(name: "test_location")
      product_id = SecureRandom.uuid
      quantity = rand(100)
      new_quantity = rand(100..1_000)

      event_store.publish(InventoryControlling::StockAdjusted.new(data: { product_id: product_id, location_id: location.id, quantity: quantity, new_quantity: new_quantity}))

      assert_equal(Stock.count, 1)
      stock = Stock.find_by(product_id: product_id)
      assert_equal(stock.quantity, new_quantity)
    end
  end
end