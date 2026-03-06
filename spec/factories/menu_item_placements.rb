FactoryBot.define do
  factory :menu_item_placement do
    menu
    menu_item
    price { "9.99" }
  end
end
