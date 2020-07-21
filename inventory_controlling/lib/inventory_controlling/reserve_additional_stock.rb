module InventoryControlling
  class ReserveAdditionalStock < Command
    attribute :order_id, Types::UUID
    attribute :product_id, Types::UUID
    attribute :quantity, Types::Quantity

    alias :aggregate_id :product_id
  end
end