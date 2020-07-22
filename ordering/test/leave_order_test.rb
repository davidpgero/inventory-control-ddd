require_relative 'test_helper'

module Ordering
  class LeaveOrderTest < ActiveSupport::TestCase
    include TestCase

    cover 'Ordering::PrepareOrder'

    test "order is left" do
      aggregate_id = SecureRandom.uuid
      product = ::Product.create(uid: SecureRandom.uuid, name: "test_product")
      location = ::Location.create(name: "test_location")
      quantity = rand(1..100)

      stream = "InventoryControlling::Product$#{product.uid}"
      arrange(stream, [
          InventoryControlling::StockCameIn.new(data: {product_id: product.uid, location_id: location.id, quantity: quantity}),
      ])

      stream = "Ordering::Order$#{aggregate_id}"
      arrange(stream, [
          OrderPlaced.new(data: {order_id: aggregate_id, product_id: product.uid, quantity: quantity}),
          OrderPrepared.new(data: {order_id: aggregate_id, product_id: product.uid}),
      ])

      published = act(stream, LeaveOrder.new(order_id: aggregate_id, product_id: product.uid))
      assert_changes(published, [
          OrderLeft.new(data: {order_id: aggregate_id, product_id: product.uid}),
      ])
    end
  end
end