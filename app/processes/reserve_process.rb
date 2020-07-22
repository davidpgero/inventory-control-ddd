class ReserveProcess
  def initialize(store: Rails.configuration.event_store,
                 bus: Rails.configuration.command_bus)
    @store = store
    @bus = bus
  end

  def call(event)
    case event
    when Ordering::OrderPlaced
      @order_id = event.data.fetch(:order_id)
      @product_id = event.data.fetch(:product_id)
      @quantity = event.data.fetch(:quantity)
      reserve
    when InventoryControlling::AdditionalStockReserved
      @order_id = event.data.fetch(:order_id)
      @product_id = event.data.fetch(:product_id)
      @quantity = event.data.fetch(:quantity)
      reserve
    end
  end

  private
  attr_reader :store, :bus

  def reserve
    first_stock = get_first_stock
    if first_stock.quantity == @quantity
      reserve_cmd = InventoryControlling::ReserveStock.new(product_id: @product_id, location_id: first_stock.location_id, quantity: @quantity)
      bus.(reserve_cmd)

      prepare_cmd = Ordering::PrepareOrder.new(order_id: @order_id, product_id: @product_id)
      bus.(prepare_cmd)
    end

    if first_stock.quantity < @quantity
      new_quantity = @quantity - first_stock.quantity
      reserve_cmd = InventoryControlling::ReserveStock.new(product_id: @product_id, location_id: first_stock.location_id, quantity: first_stock.quantity)
      reserve_additional_cmd = InventoryControlling::ReserveAdditionalStock.new(order_id: @order_id, product_id: @product_id, quantity: new_quantity)
      bus.(reserve_cmd)
      bus.(reserve_additional_cmd)
    end

    if first_stock.quantity > @quantity
      new_quantity = first_stock.quantity - @quantity
      adjust_cmd = InventoryControlling::AdjustStock.new(product_id: @product_id, location_id: first_stock.location_id, quantity: first_stock.quantity, new_quantity: @quantity)
      come_in_cmd = InventoryControlling::ComeInStock.new(product_id: @product_id, location_id: first_stock.location_id, quantity: new_quantity)
      reserve_cmd = InventoryControlling::ReserveStock.new(product_id: @product_id, location_id: first_stock.location_id, quantity: @quantity)
      bus.(adjust_cmd)
      bus.(come_in_cmd)
      bus.(reserve_cmd)

      prepare_cmd = Ordering::PrepareOrder.new(order_id: @order_id, product_id: @product_id)
      bus.(prepare_cmd)
    end
  end

  def get_first_stock
    InventoryControls::Stock.find_by!(product_id: @product_id)
  end
end