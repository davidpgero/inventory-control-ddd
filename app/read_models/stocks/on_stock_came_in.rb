module Stocks
  class OnStockCameIn
    def call(event)
      new_stock = Stock.new(product_id: event.data[:product_id], quantity: event.data[:quantity], location_id: event.data[:location_id])
      new_stock.save!
    end
  end
end