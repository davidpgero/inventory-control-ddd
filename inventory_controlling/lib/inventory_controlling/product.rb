require 'aggregate_root'

module InventoryControlling
  class Product
    include AggregateRoot

    StockNotFound = Class.new(StandardError)

    def initialize(id)
      @id = id
      @state = :available
      @stocks = []
    end

    def come_in(location_id, quantity)
      apply StockCameIn.new(data: { product_id: @id, location_id: location_id, quantity: quantity } )
    end

    def come_out(location_id, quantity)
      @current_stock = find_stock(location_id, quantity)
      raise StockNotFound unless @current_stock
      apply StockCameOut.new(data: { product_id: @id, location_id: location_id, quantity: quantity } )
    end

    def adjust(location_id, quantity, new_quantity)
      @current_stock = find_stock(location_id, quantity)
      raise StockNotFound unless @current_stock
      apply StockAdjusted.new(data: { product_id: @id, location_id: location_id, quantity: quantity, new_quantity: new_quantity } )
    end

    def transfer(location_id, quantity, new_location_id)
      @current_stock = find_stock(location_id, quantity)
      raise StockNotFound unless @current_stock
      apply StockTransferred.new(data: { product_id: @id, location_id: location_id, quantity: quantity, new_location_id: new_location_id } )
    end

    def reserve(location_id, quantity)
      @current_stock = find_stock(location_id, quantity)
      raise StockNotFound unless @current_stock
      apply StockReserved.new(data: { product_id: @id, location_id: location_id, quantity: quantity } )
    end

    def leave(location_id, quantity)
      @current_stock = find_stock(location_id, quantity)
      raise StockNotFound unless @current_stock
      apply StockLeft.new(data: { product_id: @id, location_id: location_id, quantity: quantity } )
    end

    def reserve_additional(order_id, quantity)
      apply AdditionalStockReserved.new(data: { product_id: @id, order_id: order_id, quantity: quantity } )
    end

    on StockCameIn do |event|
      @location_id = event.data[:location_id]
      @quantity = event.data[:quantity]
      come_in_stock
    end

    on StockCameOut do |event|
      @location_id = event.data[:location_id]
      @quantity = event.data[:quantity]
      @current_stock = find_stock(@location_id, @quantity)
      come_out_stock
    end

    on StockAdjusted do |event|
      @location_id = event.data[:location_id]
      @quantity = event.data[:quantity]
      @new_quantity = event.data[:new_quantity]
      @current_stock = find_stock(@location_id, @quantity)
      adjust_stock
    end

    on StockTransferred do |event|
      @location_id = event.data[:location_id]
      @new_location_id = event.data[:new_location_id]
      @quantity = event.data[:quantity]
      @current_stock = find_stock(@location_id, @quantity)
      transfer_stock
    end

    on StockReserved do |event|
      @location_id = event.data[:location_id]
      @quantity = event.data[:quantity]
      @current_stock = find_stock(@location_id, @quantity)
      reserve_stock
    end

    on StockLeft do |event|
      @location_id = event.data[:location_id]
      @quantity = event.data[:quantity]
      @current_stock = find_stock(@location_id, @quantity)
      leave_stock
    end

    on AdditionalStockReserved do |event|
      @quantity = event.data[:quantity]
      @order_id = event.data[:order_id]
      reserve_additional_stock
    end

    private

    def come_in_stock
      @stocks << Stock.new(@id, @location_id, @quantity)
    end

    def come_out_stock
      @stocks.delete(@current_stock)
    end

    def adjust_stock
      @stocks.delete(@current_stock)

      @stocks << Stock.new(@id, @location_id, @new_quantity, @current_stock.state)
    end

    def transfer_stock
      @stocks.delete(@current_stock)

      @stocks << Stock.new(@id, @new_location_id, @quantity, @current_stock.state)
    end

    def reserve_stock
      @current_stock.state = :reserved
    end

    def leave_stock
      @current_stock.state = :left
    end

    def reserve_additional_stock
      true
    end

    def find_stock(location_id, quantity = nil)
      if quantity
        @stocks.select { |stock| stock.product_id == @id && stock.location_id == location_id && stock.quantity == quantity }.first
      else
        @stocks.select { |stock| stock.product_id == @id && stock.location_id == location_id }.first
      end
    end
  end
end