require_relative 'test_helper'

module Ordering
  class PrepareOrderTest < ActiveSupport::TestCase
    include TestCase

    cover 'Ordering::PrepareOrder'

    test "order is prepared" do
      aggregate_id = SecureRandom.uuid

      stream = "Ordering::Order$#{aggregate_id}"
      published = act(stream, PrepareOrder.new(order_id: aggregate_id))
      assert_changes(published, [OrderPrepared.new(data: {order_id: aggregate_id})])
    end
  end
end