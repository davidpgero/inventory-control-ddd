module InventoryControlling
  class OnReserveStock
    include CommandHandler

    def call(command)
      with_aggregate(Product, command.aggregate_id) do |product|
        product.reserve(command.location_id, command.quantity)
      end
    end
  end
end