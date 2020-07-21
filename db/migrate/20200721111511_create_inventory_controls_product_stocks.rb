class CreateInventoryControlsProductStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :inventory_controls_product_stocks do |t|
      t.string :product_id
      t.integer :quantity, default: 0
    end
  end
end
