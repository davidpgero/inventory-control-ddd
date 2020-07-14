module InventoryControlling
  class OnTransferStock
    include CommandHandler

    def call(command)
      with_aggregate(Product, command.aggregate_id) do |product|
        product.transfer(command.location_id, command.quantity, command.new_location_id)
      end
    end
  end
end