# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#

[
  { uid: SecureRandom.uuid, name: "Plan Basket"},
  { uid: SecureRandom.uuid, name: "Inspire Basket"},
  { uid: SecureRandom.uuid, name: "Monster Basket"},
].each do |line|
  Stocks::Product.create(line)
end

[
  { name: "Connect Location", address: "4977  Polk Street"},
  { name: "Expedition Location", address: "2565  Goldcliff Circle"},
  { name: "Pilot Location", address: "52  Gnatty Creek Road"},
].each do |line|
  Stocks::Location.create(line)
end