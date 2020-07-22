module InventoryControls
  class OnStockHandler
    def call(event)
      case event
      when InventoryControlling::StockCameIn
        on_stock_came_in(event)
      when InventoryControlling::StockCameOut
        on_stock_came_out(event)
      when InventoryControlling::StockAdjusted
        on_stock_adjusted(event)
      when InventoryControlling::StockTransferred
        on_stock_transferred(event)
      when InventoryControlling::StockReserved
        on_stock_reserved(event)
      when InventoryControlling::StockLeft
        on_stock_left(event)
      else
        raise ArgumentError(event)
      end
    end

    private

    def on_stock_came_in(event)
      product = ::Product.find_by!(uid: event.data[:product_id])
      location = ::Location.find_by!(id: event.data[:location_id])
      quantity = event.data[:quantity]

      new_stock = new_stock(product, location, quantity)
      new_stock.save!
    end

    def on_stock_came_out(event)
      with_current_stock(event) do |current_stock|
        current_stock.destroy!
      end
    end

    def on_stock_adjusted(event)
      product = ::Product.find_by!(uid: event.data[:product_id])
      location = ::Location.find_by!(id: event.data[:location_id])
      new_quantity = event.data[:new_quantity]

      with_current_stock(event) do |current_stock|
        current_stock.destroy!

        new_stock = new_stock(product, location, new_quantity)
        new_stock.save!
      end
    end

    def on_stock_transferred(event)
      product = ::Product.find_by!(uid: event.data[:product_id])
      quantity = event.data[:quantity]

      new_location = ::Location.find_by!(id: event.data[:new_location_id])

      with_current_stock(event) do |current_stock|
        current_stock.destroy!

        new_stock = new_stock(product, new_location, quantity)
        new_stock.save!
      end
    end

    def on_stock_reserved(event)
      product = ::Product.find_by!(uid: event.data[:product_id])
      location = ::Location.find_by!(id: event.data[:location_id])
      quantity = event.data[:quantity]

      with_current_stock(event) do |current_stock|
        current_stock.destroy!

        new_stock = new_stock(product, location, quantity, :reserved)
        new_stock.save!
      end
    end

    def on_stock_left(event)
      product = ::Product.find_by!(uid: event.data[:product_id])
      location = ::Location.find_by!(id: event.data[:location_id])
      quantity = event.data[:quantity]

      with_current_stock(event) do |current_stock|
        current_stock.destroy!

        new_stock = new_stock(product, location, quantity, :left)
        new_stock.save!
      end
    end

    def with_current_stock(event)
      Stock.transaction do
        current_stock = Stock.find_by!(product_id: event.data[:product_id], quantity: event.data[:quantity], location_id: event.data[:location_id])
        yield(current_stock)
      end
    end

    def new_stock(product, location, quantity, state = :new)
      Stock.new(
          product_id: product.uid,
          product_name: product.name,
          location_id: location.id,
          location_name: location.name,
          location_address: location.address,
          quantity: quantity,
          state: state
      )
    end
  end
end