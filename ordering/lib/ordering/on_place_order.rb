module Ordering
  class OnPlaceOrder
    include CommandHandler

    def call(command)
      with_aggregate(Order, command.aggregate_id) do |order|
        order.place(command.product_id, command.quantity)
      end
    end
  end
end