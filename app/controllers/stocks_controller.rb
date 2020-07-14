class StocksController < ApplicationController
  def come_in
    if request.post?
      cmd = InventoryControl::ComeInStock.new(product_id: id, location_id: location_id, quantity: quantity)
      command_bus.(cmd)

      redirect_to product_path(Stocks::Product.find_by_uid(cmd.product_id).uid), notice: 'Stock was added successfully.'
    else
      @product_id = params[:id]
      @locations = Stocks::Location.all
      @stock = Stocks::Stock.new(product_id: @product_id)
    end
  end

  def come_out
    cmd = InventoryControl::ComeOutStock.new(product_id: id, location_id: location_id, quantity: quantity)
    command_bus.(cmd)

    redirect_to product_path(Stocks::Product.find_by_uid(cmd.product_id).uid), notice: 'Stock was came out successfully.'
  end

  def adjust
    cmd = InventoryControl::AdjustStock.new(product_id: params[:id], location_id: params[:location_id], quantity: params[:quantity], new_quantity: params[:new_quantity])
    command_bus.(cmd)

    redirect_to product_path(InventoryControl::Product.find_by_uid(cmd.product_id)), notice: 'Stock was adjusted successfully.'
  end

  def transfer
    cmd = InventoryControl::TransferStock.new(product_id: params[:id], location_id: params[:location_id], quantity: params[:quantity], new_location_id: params[:new_location_id])
    command_bus.(cmd)

    redirect_to product_path(InventoryControl::Product.find_by_uid(cmd.product_id)), notice: 'Stock was transferred successfully.'
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
end