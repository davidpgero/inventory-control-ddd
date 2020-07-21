module Ordering
  class PrepareOrder < Command
    attribute :order_id, Types::UUID
    attribute :product_id, Types::UUID

    alias :aggregate_id :order_id
  end
end