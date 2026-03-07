module Import
  class RestaurantDataService
    def initialize(json_data)
      @data = json_data
      @results = []
    end

    def call
      ActiveRecord::Base.transaction do
        process_restaurants
      end

      @results
    end

    private

    def process_restaurants
      @data["restaurants"].each do |restaurant_data|
        restaurant = Restaurant.find_or_create_by!(name: restaurant_data["name"])

        process_menus(restaurant, restaurant_data["menus"])
      end
    end

    def process_menus(restaurant, menus_data)
      menus_data.each do |menu_data|
        menu = restaurant.menus.find_or_create_by!(name: menu_data["name"])

        items = menu_data["dishes"] || menu_data["menu_items"]

        process_items(menu, items)
      end
    end

    def process_items(menu, items_data)
      items_data.each do |item_data|
        begin
          item = MenuItem.find_or_create_by!(name: item_data["name"]) do |i|
            i.description = item_data["description"]
          end

          placement = menu.menu_item_placements.find_or_create_by!(
            menu_item: item,
            price: item_data["price"]
          )

          @results << {
            restaurant: menu.restaurant.name,
            menu: menu.name,
            item: item.name,
            status: :success
          }
        rescue => e

          @results << {
            restaurant: menu.restaurant.name,
            menu: menu.name,
            item: item_data["name"],
            status: :error,
            error: e.message
          }
        end
      end
    end
  end
end