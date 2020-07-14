module InventoryControls
  class OnStockCameOut
    def call(event)
      @stock = Stock.find_by(product_id: event.data[:product_id], quantity: event.data[:quantity], location_id: event.data[:location_id])
      @stock.destroy! if @stock
    end
  end
end