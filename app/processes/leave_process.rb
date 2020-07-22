class LeaveProcess
  def initialize(store: Rails.configuration.event_store,
                 bus: Rails.configuration.command_bus)
    @store = store
    @bus = bus
  end

  def call(event)
    case event
    when Ordering::OrderLeft
      @order_id = event.data.fetch(:order_id)
      @product_id = event.data.fetch(:product_id)
      stock_leave
    when Ordering::OrderPrepared
      @order_id = event.data.fetch(:order_id)
      @product_id = event.data.fetch(:product_id)
      order_leave
    end
  end

  private
  attr_reader :store, :bus

  def stock_leave
    reserved_stocks = InventoryControls::Stock.where(product_id: @product_id, state: :reserved)
    reserved_stocks.each do |reserved_stock|
      leave_stock_cmd = InventoryControlling::LeaveStock.new(product_id: reserved_stock.product_id, location_id: reserved_stock.location_id, quantity: reserved_stock.quantity)
      bus.(leave_stock_cmd)
    end
  end

  def order_leave
    leave_order_cmd = Ordering::LeaveOrder.new(order_id: @order_id, product_id: @product_id)
    bus.(leave_order_cmd)
  end
end
