require 'aggregate_root'

module Ordering
  class Order
    include AggregateRoot

    def initialize(id)
      @id = id
      @state = :new
    end

    def place(product_id, quantity)
      apply OrderPlaced.new({ order_id: @id, product_id: product_id, quantity: quantity })
    end

    def prepare
      apply OrderPrepared.new({ order_id: @id })
    end

    def leave
      apply OrderLeft.new({ order_id: @id })
    end

    on OrderPlaced do |event|
      @product_id = event.data[:product_id]
      @quantity = event.data[:quantity]
      @new_state = :placed
      order_placed
    end

    on OrderPrepared do |event|
      @new_state = :prepared
      order_prepared
    end

    on OrderLeft do |event|
      @new_state = :left
      order_left
    end

    private

    def order_placed
      @state = @new_state
    end

    def order_prepared
      @state = @new_state
    end

    def order_left
      @state = @new_state
    end
  end
end