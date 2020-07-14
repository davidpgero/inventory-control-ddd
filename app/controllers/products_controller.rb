class ProductsController < ApplicationController
  def index
    @products = InventoryControls::Product.all
  end

  def show
    @product = InventoryControls::Product.find_by_uid(params[:id])
    @stocks = InventoryControls::Stock.where(product_id: @product.uid)
  end
end