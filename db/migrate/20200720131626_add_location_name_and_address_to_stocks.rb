class AddLocationNameAndAddressToStocks < ActiveRecord::Migration[5.2]
  def change
    add_column :stocks, :location_name, :string
    add_column :stocks, :location_address, :string
  end
end
