module InventoryControlling
  class OnReserveAdditionalStock
    include CommandHandler

    def call(command)
      with_aggregate(Product, command.aggregate_id) do |product|
        product.reserve_additional(command.quantity)
      end
    end
  end
end