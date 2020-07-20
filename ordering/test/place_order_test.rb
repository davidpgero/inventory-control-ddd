require_relative 'test_helper'

module Ordering
  class PlaceOrderTest < ActiveSupport::TestCase
    include TestCase

    cover 'Ordering::PlaceOrder'

    test "order is placed" do
      aggregate_id = SecureRandom.uuid
      product = ::Product.create(uid: SecureRandom.uuid, name: "test_product")
      quantity = rand(100)


      stream = "Ordering::Order$#{aggregate_id}"
      published = act(stream, PlaceOrder.new(order_id: aggregate_id, product_id: product.uid, quantity: quantity))
      assert_changes(published, [OrderPlaced.new(data: {order_id: aggregate_id, product_id: product.uid, quantity: quantity})])
    end
  end
end