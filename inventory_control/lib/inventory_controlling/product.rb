require 'aggregate_root'

module InventoryControlling
  class Product
    include AggregateRoot

    MissingLocation = Class.new(StandardError)
    MissingQuantity = Class.new(StandardError)

    def initialize(id)
      @id = id
      @state = :available
      @stocks = []
    end

    def come_in(location_id, quantity)
      raise MissingLocation unless location_id
      raise MissingQuantity unless quantity
      apply StockCameIn.new(data: { product_id: @id, location_id: location_id, quantity: quantity } )
    end

    def come_out(location_id, quantity)
      raise MissingLocation unless location_id
      raise MissingQuantity unless quantity
      apply StockCameOut.new(data: { product_id: @id, location_id: location_id, quantity: quantity } )
    end

    def adjust(location_id, quantity, new_quantity)
      raise MissingLocation unless location_id
      raise MissingQuantity unless quantity && new_quantity
      apply StockAdjusted.new(data: { product_id: @id, location_id: location_id, quantity: quantity, new_quantity: new_quantity } )
    end

    def transfer(location_id, quantity, new_location_id)
      raise MissingLocation unless location_id && new_location_id
      raise MissingQuantity unless quantity
      apply StockTransferred.new(data: { product_id: @id, location_id: location_id, quantity: quantity, new_location_id: new_location_id } )
    end

    on StockCameIn do |event|
      @location_id = event.data[:location_id]
      @quantity = event.data[:quantity]
    end

    on StockCameOut do |event|
      @location_id = event.data[:location_id]
      @quantity = event.data[:quantity]
      @current_stock = find_stock(@location_id, @quantity)
      return unless @current_stock
    end

    on StockAdjusted do |event|
      @location_id = event.data[:location_id]
      @quantity = event.data[:quantity]
      @new_quantity = event.data[:new_quantity]
      @current_stock = find_stock(@location_id, @quantity)
      return unless @current_stock
      return if @quantity == @new_quantity
    end

    on StockTransferred do |event|
      @location_id = event.data[:location_id]
      @new_location_id = event.data[:new_location_id]
      @quantity = event.data[:quantity]
      @current_stock = find_stock(@location_id, @quantity)
      return unless @current_stock
      return if @location_id == @new_location_id
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

      @stocks << Stock.new(@id, @location_id, @new_quantity)
    end

    def transfer_stock
      @stocks.delete(@current_stock)

      @stocks << Stock.new(@id, @new_location_id, @quantity)
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