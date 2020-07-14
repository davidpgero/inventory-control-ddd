require 'test_helper'

module InventoryControls
  class StockTransferredTest < ActiveJob::TestCase
    test 'stock transferred' do
      event_store = Rails.configuration.event_store

      location = InventoryControls::Location.create(name: "test_location")
      new_location = InventoryControls::Location.create(name: "new_test_location")
      product_id = SecureRandom.uuid
      quantity = rand(100)

      Stock.create(product_id: product_id, quantity: quantity, location_id: location.id)

      event_store.publish(InventoryControlling::StockTransferred.new(data: { product_id: product_id, location_id: location.id, quantity: quantity, new_location_id: new_location.id}))

      assert_equal(Stock.count, 1)
      stock = Stock.find_by(product_id: product_id)
      assert_equal(stock.location_id.to_i, new_location.id.to_i)
    end

    test "stock transferred when there is not match" do
      event_store = Rails.configuration.event_store

      location = InventoryControls::Location.create(name: "test_location")
      new_location = InventoryControls::Location.create(name: "new_test_location")
      product_id = SecureRandom.uuid
      quantity = rand(100)

      event_store.publish(InventoryControlling::StockTransferred.new(data: { product_id: product_id, location_id: location.id, quantity: quantity, new_location_id: new_location.id}))

      assert_equal(Stock.count, 1)
      stock = Stock.find_by(product_id: product_id)
      assert_equal(stock.location_id.to_i, new_location.id.to_i)
    end
  end
end