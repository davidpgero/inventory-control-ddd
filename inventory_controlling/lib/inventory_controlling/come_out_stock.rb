module InventoryControlling
  class ComeOutStock < Command
    attribute :product_id, Types::UUID
    attribute :location_id, Types::ID
    attribute :quantity, Types::Integer

    alias :aggregate_id :product_id
  end
end