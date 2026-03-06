# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb
MenuItem.destroy_all
Menu.destroy_all

lunch_menu = Menu.create!(
  name: "Lunch Menu",
)

dinner_menu = Menu.create!(
  name: "Dinner Menu",
)

MenuItem.create!([
  { name: "Burger", description: "A classic beef burger with cheese.", price: 9.00, menu: lunch_menu },
  { name: "Small Salad", description: "Fresh greens with vinaigrette.", price: 5.00, menu: lunch_menu },
  { name: "Chicken Wings", description: "6 pieces of buffalo wings.", price: 9.00, menu: lunch_menu }
])

MenuItem.create!([
  { name: "Mega Burger", description: "Double patty beef burger with bacon.", price: 15.00, menu: dinner_menu },
  { name: "Large Salad", description: "Healthy greens with grilled chicken.", price: 8.00, menu: dinner_menu },
  { name: "Lobster Mac & Cheese", description: "Decadent mac and cheese with lobster chunks.", price: 31.00, menu: dinner_menu }
])

puts "Done."
