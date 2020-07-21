class CreateOrdersOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders_orders do |t|
      t.string :uid
      t.string :product_name
      t.integer :quantity
      t.string :state
    end
  end
end
