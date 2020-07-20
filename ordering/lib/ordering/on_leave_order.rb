module Ordering
  class OnLeaveOrder
    include CommandHandler

    def call(command)
      with_aggregate(Order, command.aggregate_id) do |order|
        order.leave
      end
    end
  end
end