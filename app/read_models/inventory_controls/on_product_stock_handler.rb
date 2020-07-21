module InventoryControls
  class OnProductStockHandler
    def call(event)
      case event
      when InventoryControlling::StockCameIn
        on_product_stock_came_in(event)
      when InventoryControlling::StockCameOut
        on_product_stock_came_out(event)
      when InventoryControlling::StockAdjusted
        on_product_stock_adjusted(event)
      when InventoryControlling::StockReserved
        on_product_stock_reserved(event)
      else
        raise ArgumentError(event)
      end
    end

    private

    def on_product_stock_came_in(event)
      product_stock = ProductStock.find_or_initialize_by(product_id: event.data[:product_id])
      quantity = event.data[:quantity]

      product_stock.quantity += quantity
      product_stock.save!
    end

    def on_product_stock_came_out(event)
      product_stock = ProductStock.find_by(product_id: event.data[:product_id])
      quantity = event.data[:quantity]

      product_stock.quantity -= quantity
      product_stock.save!
    end

    def on_product_stock_adjusted(event)
      product_stock = ProductStock.find_by(product_id: event.data[:product_id])
      quantity = event.data[:quantity]
      new_quantity = event.data[:new_quantity]
      quantity_diff = quantity - new_quantity
      product_stock.quantity -= quantity_diff

      product_stock.save!
    end

    def on_product_stock_reserved(event)
      product_stock = ProductStock.find_by(product_id: event.data[:product_id])
      product_stock.quantity -= event.data[:quantity]
      product_stock.save!
    end
  end
end