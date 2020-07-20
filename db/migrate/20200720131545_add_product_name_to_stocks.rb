class AddProductNameToStocks < ActiveRecord::Migration[5.2]
  def change
    add_column :stocks, :product_name, :string
  end
end
