module Ordering
  class LeaveOrder < Command
    attribute :order_id, Types::UUID

    alias :aggregate_id :order_id
  end
end