require_relative 'test_helper'

module Ordering
  class LeaveOrderTest < ActiveSupport::TestCase
    include TestCase

    cover 'Ordering::PrepareOrder'

    test "order is left" do
      aggregate_id = SecureRandom.uuid

      stream = "Ordering::Order$#{aggregate_id}"
      published = act(stream, LeaveOrder.new(order_id: aggregate_id))
      assert_changes(published, [OrderLeft.new(data: {order_id: aggregate_id})])
    end
  end
end