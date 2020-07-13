class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :uid
      t.string :state
      t.string :name
    end
  end
end
