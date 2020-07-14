module InventoryControls
  class Stock < ApplicationRecord
    self.table_name = "stocks"

    belongs_to :location
  end
end