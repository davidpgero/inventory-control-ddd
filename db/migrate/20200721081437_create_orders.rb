class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :uid
      t.string :product_id
      t.integer :quantity
      t.string :state
    end
  end
end
