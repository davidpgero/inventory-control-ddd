require 'test_helper'

module InventoryControls
  class StockCameOutTest < ActiveJob::TestCase
    test 'stock come out' do
      event_store = Rails.configuration.event_store

      location = InventoryControls::Location.create(name: "test_location")
      product_id = SecureRandom.uuid
      quantity = rand(100)

      Stock.create(product_id: product_id, quantity: quantity, location_id: location.id)

      event_store.publish(InventoryControlling::StockCameOut.new(data: { product_id: product_id, location_id: location.id, quantity: quantity}))

      assert_equal(Stock.count, 0)
    end

    test "stock come out when two stocks are matched" do
      event_store = Rails.configuration.event_store

      location = InventoryControls::Location.create(name: "test_location")
      product_id = SecureRandom.uuid
      quantity = rand(100)

      2.times { Stock.create(product_id: product_id, quantity: quantity, location_id: location.id) }

      event_store.publish(InventoryControlling::StockCameOut.new(data: { product_id: product_id, location_id: location.id, quantity: quantity}))

      assert_equal(Stock.count, 1)
      stock = Stock.find_by(product_id: product_id)
      assert_equal(stock.product_id, product_id)
      assert_equal(stock.location_id.to_i, location.id.to_i)
      assert_equal(stock.quantity, quantity)
    end

    test "stock come out when no stock's matched" do
      event_store = Rails.configuration.event_store

      location = InventoryControls::Location.create(name: "test_location")
      product_id = SecureRandom.uuid
      quantity = rand(100)

      event_store.publish(InventoryControlling::StockCameOut.new(data: { product_id: product_id, location_id: location.id, quantity: quantity}))

      assert_equal(Stock.count, 0)
    end
  end
end