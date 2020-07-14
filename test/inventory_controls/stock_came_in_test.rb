require 'test_helper'

module InventoryControls
  class StockCameInTest < ActiveJob::TestCase
    test 'stock come in' do
      event_store = Rails.configuration.event_store

      location = InventoryControls::Location.create(name: "test_location")
      product_id = SecureRandom.uuid
      quantity = rand(100)

      event_store.publish(InventoryControlling::StockCameIn.new(data: { product_id: product_id, location_id: location.id, quantity: quantity}))

      assert_equal(Stock.count, 1)
      stock = Stock.find_by(product_id: product_id)
      assert_equal(stock.product_id, product_id)
      assert_equal(stock.location_id.to_i, location.id.to_i)
      assert_equal(stock.quantity, quantity)
    end

    test "stock come in second time" do
      event_store = Rails.configuration.event_store

      location = InventoryControls::Location.create(name: "test_location")
      product_id = SecureRandom.uuid
      quantity = rand(100)

      2.times { event_store.publish(InventoryControlling::StockCameIn.new(data: { product_id: product_id, location_id: location.id, quantity: quantity})) }

      assert_equal(Stock.count, 2)
    end
  end
end