class OrdersController < ApplicationController
  def index
    @orders = ::Order.all
  end

  def show
    @order = ::Order.find_by_uid!(params[:id])
  end

  def new
    @order = ::Order.new(uid: NewUUID.call)
  end

  def create
    if available?
      cmd = Ordering::OrderPlaced.new(id: id, product_id: product_id, quantity: quantity)
      command_bus.(cmd)

      redirect_to order_path(id), notice: 'Order was placed successfully.'
    else
      error_msg = "There is no enough in the inventory. It should be #{available_quantity} >= #{quantity}"
      redirect_to orders_path, error: error_msg
    end
  end

  private

  def id
    params[:id]
  end

  def quantity
    params[:quantity]
  end

  def product_id
    params[:product_id]
  end

  def available_quantity
    @_available_quantity ||= begin
                               product_stock = InventoryControls::ProductStock.find_by!(product_id: product_id)&.first
                               product_stock&.quantity.presence || 0
                             end
  end

  def available?
    available_quantity >= quantity
  end
end