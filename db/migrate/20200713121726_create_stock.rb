class CreateStock < ActiveRecord::Migration[5.2]
  def change
    create_table :stocks do |t|
      t.string :product_id
      t.integer :quantity
      t.integer :location_id
    end
  end
end
