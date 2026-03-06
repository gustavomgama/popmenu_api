require 'rails_helper'

RSpec.describe "Api::V1::Restaurants", type: :request do
  let!(:restaurant) { create(:restaurant, name: "Poppo's Cafe") }
  let!(:menu) { create(:menu, name: "Lunch", restaurant:) }
  let!(:burger) { create(:menu_item, name: "Burger") }
  let!(:salad) { create(:menu_item, name: "Salad") }
  let!(:placement1) { create(:menu_item_placement, menu:, menu_item: burger, price: 9.00) }
  let!(:placement2) { create(:menu_item_placement, menu:, menu_item: salad, price: 5.00) }

  describe "GET /api/v1/restaurants" do
    it "returns all restaurants with nested menus and items" do
      get "/api/v1/restaurants"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json.length).to eq(1)
      expect(json.first["name"]).to eq("Poppo's Cafe")
      expect(json.first["menus"].length).to eq(1)
      expect(json.first["menus"].first["menu_item_placements"].length).to eq(2)
    end
  end

  describe "GET /api/v1/restaurants/:id" do
    it "returns the specific restaurant with nested menus and placements" do
      get "/api/v1/restaurants/#{restaurant.id}"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["name"]).to eq("Poppo's Cafe")
      expect(json["menus"].first["name"]).to eq("Lunch")

      item_names = json["menus"].first["menu_item_placements"].map { |p| p["menu_item"]["name"] }
      expect(item_names).to include("Burger", "Salad")
    end

    it "returns 404 if restaurant is not found" do
      get "/api/v1/restaurants/9999"

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Restaurant not found")
    end
  end
end
