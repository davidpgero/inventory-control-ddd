class ProductsController < ApplicationController
  def index
    @products = Stocks::Product.all
  end

  def show
    @product = Stocks::Product.find_by_uid(params[:id])
    @stocks = Stocks::Stock.where(product_id: @product.uid)
  end
end