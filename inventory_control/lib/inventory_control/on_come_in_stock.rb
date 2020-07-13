module InventoryControl
  class OnComeInStock
    include CommandHandler

    def call(command)
      with_aggregate(Product, command.aggregate_id) do |product|
        product.come_in(command.location_id, command.quantity)
      end
    end
  end
end