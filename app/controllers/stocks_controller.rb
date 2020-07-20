class StocksController < ApplicationController
  def come_in
    if request.post?
      cmd = InventoryControlling::ComeInStock.new(product_id: id, location_id: location_id, quantity: quantity)
      command_bus.(cmd)

      redirect_to product_path(product_uid(cmd)), notice: 'Stock was added successfully.'
    else
      @product_id = id
      @locations = ::Location.all
    end
  end

  def come_out
    cmd = InventoryControlling::ComeOutStock.new(product_id: id, location_id: location_id, quantity: quantity)
    command_bus.(cmd)

    redirect_to product_path(product_uid(cmd)), notice: 'Stock was came out successfully.'
  end

  def adjust
    if request.post?
      cmd = InventoryControlling::AdjustStock.new(product_id: id, location_id: location_id, quantity: quantity, new_quantity: params[:new_quantity].to_i)
      command_bus.(cmd)

      redirect_to product_path(product_uid(cmd)), notice: 'Stock was adjusted successfully.'
    else
      @stock = find_stock
      @location = ::Location.find(@stock.location_id)
    end
  end

  def transfer
    if request.post?
      cmd = InventoryControlling::TransferStock.new(product_id: id, location_id: location_id, quantity: quantity, new_location_id: params[:new_location_id].to_i)
      command_bus.(cmd)

      redirect_to product_path(product_uid(cmd)), notice: 'Stock was transferred successfully.'
    else
      @stock = find_stock
      @locations = ::Location.all
    end
  end

  private

  def id
    params[:id]
  end

  def location_id
    params[:location_id].to_i
  end

  def quantity
    params[:quantity].to_i
  end

  def product_uid(cmd)
    ::Product.find_by_uid(cmd.product_id).uid
  end

  def find_stock
    InventoryControls::Stock.find_by!(product_id: id, location_id: location_id, quantity: quantity)
  end
end