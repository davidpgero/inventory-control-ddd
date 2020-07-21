module Orders
  class OnOrderHandler
    def call(event)
      case event
      when Ordering::OrderPlaced
        on_order_placed(event)
      when Ordering::OrderPrepared
        on_order_prepared(event)
      when Ordering::OrderLeft
        on_order_left(event)
      else
        raise ArgumentError(event)
      end
    end

    private

    def on_order_placed(event)
      product = ::Product.find_by!(uid: event.data[:product_id])

      new_order = Order.new(uid: event.data[:order_id], product_name: product.name, quantity: event.data[:quantity], state: :placed)
      new_order.save!
    end

    def on_order_prepared(event)
      order = Order.find_by(uid: event.data[:order_id])
      order.state = :prepared
      order.save!
    end

    def on_order_left(event)
      order = Order.find_by(uid: event.data[:order_id])
      order.state = :left
      order.save!
    end
  end
end