module InventoryControl
  class TransferStock < Command
    attribute :product_id, Types::UUID
    attribute :location_id, Types::UUID
    attribute :new_location_id, Types::UUID
    attribute :quantity, Types::Integer

    alias :aggregate_id :product_id
  end
end