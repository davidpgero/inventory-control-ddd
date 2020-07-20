module Ordering
  class OrderPlaced < Event
    attribute :order_id, Types::UUID
    attribute :product_id, Types::UUID
    attribute :quantity, Types::Quantity

    alias :aggregate_id :order_id
  end
end