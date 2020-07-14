module InventoryControl
  class OnComeOutStock
    include CommandHandler

    def call(command)
      with_aggregate(Product, command.aggregate_id) do |product|
        product.come_out(command.location_id, command.quantity)
      end
    end
  end
end