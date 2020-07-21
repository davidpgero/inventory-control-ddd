class ProductsController < ApplicationController
  def index
    @products = ::Product.all
  end

  def show
    @product = ::Product.find_by_uid(params[:id])
    @stock_product = InventoryControls::ProductStock.find_or_initialize_by(product_id: params[:id])
    @stocks = InventoryControls::Stock.where(product_id: @product.uid)
  end
end