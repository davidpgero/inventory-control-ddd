module Stocks
  class OnStockTransferred
    def call(event)
      Stock.transaction do
        @stock = Stock.find_by(product_id: event.data[:product_id], quantity: event.data[:quantity], location_id: event.data[:location_id])
        @stock.destroy! if @stock

        @new_stock = Stock.new(product_id: event.data[:product_id], quantity: event.data[:quantity], location_id: event.data[:new_location_id])
        @new_stock.save! if @new_stock
      end
    end
  end
end