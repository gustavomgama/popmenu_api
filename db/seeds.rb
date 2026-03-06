puts "Clearing old records..."
MenuItemPlacement.destroy_all
MenuItem.destroy_all
Menu.destroy_all
Restaurant.destroy_all

puts "Creating Restaurant..."
restaurant = Restaurant.create!(name: "Poppo's Cafe")

puts "Creating Menus..."
lunch  = Menu.create!(name: "Lunch",  restaurant:)
dinner = Menu.create!(name: "Dinner", restaurant:)

puts "Creating Menu Items..."
burger  = MenuItem.create!(name: "Burger",               description: "Classic beef burger")
salad   = MenuItem.create!(name: "Small Salad",          description: "Fresh greens with vinaigrette")
wings   = MenuItem.create!(name: "Chicken Wings",        description: "6 pieces of buffalo wings")
lobster = MenuItem.create!(name: "Lobster Mac & Cheese", description: "Decadent mac and cheese with lobster")

puts "Creating Placements..."
MenuItemPlacement.create!([
  { menu: lunch,  menu_item: burger,  price: 9.00 },
  { menu: lunch,  menu_item: salad,   price: 5.00 },
  { menu: lunch,  menu_item: wings,   price: 9.00 },
  { menu: dinner, menu_item: burger,  price: 15.00 },
  { menu: dinner, menu_item: lobster, price: 31.00 }
])

puts "Seeding complete! #{Restaurant.count} restaurant, #{Menu.count} menus, #{MenuItem.count} items, #{MenuItemPlacement.count} placements."
