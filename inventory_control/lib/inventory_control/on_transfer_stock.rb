module InventoryControl
  class OnTransferStock
    include CommandHandler

    def call(command)
      with_aggregate(Product, command.aggregate_id) do |product|
        product.transfer_stock
      end
    end
  end
end