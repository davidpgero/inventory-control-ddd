module InventoryControl
  class OnAdjustStock
    include CommandHandler

    def call(command)
      with_aggregate(Product, command.aggregate_id) do |product|
        product.adjust(command.location_id, command.quantity, command.new_quantity)
      end
    end
  end
end