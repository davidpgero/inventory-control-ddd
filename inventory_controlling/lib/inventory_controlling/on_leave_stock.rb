module InventoryControlling
  class OnLeaveStock
    include CommandHandler

    def call(command)
      with_aggregate(Product, command.aggregate_id) do |product|
        product.leave(command.location_id, command.quantity)
      end
    end
  end
end