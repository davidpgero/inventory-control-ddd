require 'test_helper'

module InventoryControls
  class StockCameOutTest < ActiveJob::TestCase
    test 'stock come out' do
      event_store = Rails.configuration.event_store

      location = ::Location.create(name: "test_location")
      product = ::Product.create(uid: SecureRandom.uuid, name: "test_product")
      quantity = rand(100)
      product_id = product.uid

      Stock.create(product_id: product_id, location_id: location.id, quantity: quantity)

      assert_equal(Stock.count, 1)
      stock = Stock.find_by(product_id: product_id)
      assert_equal(stock.product_id, product_id)

      event_store.publish(InventoryControlling::StockCameOut.new(data: { product_id: product_id, location_id: location.id, quantity: quantity }))

      assert_equal(Stock.count, 0)
    end
  end
end