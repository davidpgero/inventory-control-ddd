class StocksController < ApplicationController
  def come_in
    if request.post?
      cmd = InventoryControl::ComeInStock.new(product_id: id, location_id: location_id, quantity: quantity)
      command_bus.(cmd)

      redirect_to product_path(product_uid(cmd)), notice: 'Stock was added successfully.'
    else
      @product_id = id
      @locations = Stocks::Location.all
      @stock = Stocks::Stock.new(product_id: @product_id)
    end
  end

  def come_out
    cmd = InventoryControl::ComeOutStock.new(product_id: id, location_id: location_id, quantity: quantity)
    command_bus.(cmd)

    redirect_to product_path(product_uid(cmd)), notice: 'Stock was came out successfully.'
  end

  def adjust
    if request.post?
      cmd = InventoryControl::AdjustStock.new(product_id: id, location_id: location_id, quantity: quantity, new_quantity: params[:new_quantity])
      command_bus.(cmd)

      redirect_to product_path(product_uid(cmd)), notice: 'Stock was adjusted successfully.'
    else
      @product_id = id
      @location_id = location_id
      @quantity = quantity

      @location = Stocks::Location.find(@location_id)
    end
  end

  def transfer
    cmd = InventoryControl::TransferStock.new(product_id: params[:id], location_id: params[:location_id], quantity: params[:quantity], new_location_id: params[:new_location_id])
    command_bus.(cmd)

    redirect_to product_path(product_uid(cmd)), notice: 'Stock was transferred successfully.'
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
    Stocks::Product.find_by_uid(cmd.product_id).uid
  end
end