module Ordering
  class OnLeaveOrder
    include CommandHandler

    def call(command)
      with_aggregate(Order, command.aggregate_id) do |order|
        order.leave(command.product_id)
      end
    end
  end
end