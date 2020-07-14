module InventoryControls
  class Location < ApplicationRecord
    self.table_name = "locations"

    has_many :stocks
  end
end