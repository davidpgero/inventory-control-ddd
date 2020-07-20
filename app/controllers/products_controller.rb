class ProductsController < ApplicationController
  def index
    @products = ::Product.all
  end

  def show
    @product = ::Product.find_by_uid(params[:id])
    @stocks = InventoryControls::Stock.where(product_id: @product.uid)
  end
end