class StockLeaveProcess
  def initialize(store: Rails.configuration.event_store,
                 bus: Rails.configuration.command_bus)
    @store = store
    @bus = bus
  end

  def call(event)
    case event
    when Ordering::OrderPrepared
      @order_id = event.data.fetch(:order_id)
      order_leave
    end
  end

  private
  attr_reader :store, :bus

  def order_leave
    prepared_stocks = InventoryControls::Stock.where(product_id: @product_id, state: :prepared)
    prepared_stocks.each do |prepare_stock|
      leave_stock_cmd = InventoryControlling::LeaveStock.new(product_id: @product_id)
      bus.(leave_stock_cmd)
    end
    leave_order_cmd = Ordering::LeaveOrder.new(order_id: @order_id)
    bus.(leave_order_cmd)
  end
end
