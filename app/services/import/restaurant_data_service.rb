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

      summary_result(status: @results.any? { |r| r[:status] == :error } ? "partial_success" : "success")
    rescue => e
      summary_result(status: "error", message: "Fatal error: #{e.message}")
    end

    private

    def summary_result(status:, message: nil)
      {
        status:,
        message:,
        total_processed: @results.count,
        success_count: @results.count { |r| r[:status] == :success },
        error_count: @results.count { |r| r[:status] == :error },
        results: @results
      }.compact
    end

    def process_restaurants
      return if @data["restaurants"].blank?

      @data["restaurants"].each do |restaurant_data|
        restaurant = Restaurant.find_or_initialize_by(name: restaurant_data["name"])
        restaurant.save!

        process_menus(restaurant, restaurant_data["menus"])
      end
    end

    def process_menus(restaurant, menus_data)
      return if menus_data.blank?

      menus_data.each do |menu_data|
        menu = restaurant.menus.find_or_initialize_by(name: menu_data["name"])
        menu.save!

        items = menu_data["dishes"] || menu_data["menu_items"]
        process_items(menu, items)
      end
    end

    def process_items(menu, items_data)
      return if items_data.blank?

      items_data.each do |item_data|
        begin
          item = MenuItem.find_or_initialize_by(name: item_data["name"])
          item.description = item_data["description"]
          item.save!

          placement = menu.menu_item_placements.find_or_initialize_by(
            menu_item: item
          )
          placement.price = item_data["price"]
          placement.save!

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
