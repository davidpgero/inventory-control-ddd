require 'test_helper'
path = Rails.root.join('inventory_controlling/test')

Dir.glob("#{path}/**/*_test.rb") do |file|
  require file
end