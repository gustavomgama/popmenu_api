FactoryBot.define do
  factory :menu_item do
    name { "Burger" }
    description { "Beef with cheese" }
    price { "9.99" }
    menu
  end
end
