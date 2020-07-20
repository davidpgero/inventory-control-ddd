require 'test_helper'

module InventoryControls
  class StockTransferredTest < ActiveJob::TestCase
    test 'stock transferred' do
      event_store = Rails.configuration.event_store

      product_id = SecureRandom.uuid
      location = ::Location.create(name: "test_location", address: "test_address")
      product = ::Product.create(uid: product_id, name: "test_product")
      quantity = rand(100)

      new_location = ::Location.create(name: "new_test_location", address: "new_test_address")

      Stock.create(product_id: product_id, quantity: quantity, location_id: location.id)

      event_store.publish(InventoryControlling::StockTransferred.new(data: { product_id: product_id, location_id: location.id, quantity: quantity, new_location_id: new_location.id}))

      assert_equal(Stock.count, 1)
      stock = Stock.find_by(product_id: product_id)
      assert_equal(stock.location_id.to_i, new_location.id.to_i)
    end
  end
end