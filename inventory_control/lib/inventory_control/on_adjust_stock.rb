module InventoryControl
  class OnAdjustStock
    include CommandHandler

    def call(command)
      with_aggregate(Product, command.aggregate_id) do |product|
        product.adjust_stock
      end
    end
  end
end