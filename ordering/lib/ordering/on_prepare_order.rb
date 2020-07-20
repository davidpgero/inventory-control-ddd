module Ordering
  class OnPrepareOrder
    include CommandHandler

    def call(command)
      with_aggregate(Order, command.aggregate_id) do |order|
        order.prepare
      end
    end
  end
end