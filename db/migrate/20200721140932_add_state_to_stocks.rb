class AddStateToStocks < ActiveRecord::Migration[5.2]
  def change
    add_column :stocks, :state, :string
  end
end
