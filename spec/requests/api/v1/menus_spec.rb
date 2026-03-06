require 'rails_helper'

RSpec.describe "Api::V1::Menus", type: :request do
  let!(:restaurant) { create(:restaurant) }
  let!(:menu) { create(:menu, name: "Lunch", restaurant:) }
  let!(:steak) { create(:menu_item, name: "Steak") }
  let!(:salad) { create(:menu_item, name: "Salad") }
  let!(:placement1) { create(:menu_item_placement, menu:, menu_item: steak, price: 25.00) }
  let!(:placement2) { create(:menu_item_placement, menu:, menu_item: salad, price: 10.00) }

  describe "GET /api/v1/menus" do
    it "returns all menus with nested menu items" do
      get "/api/v1/menus"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json.length).to eq(1)
      expect(json.first["name"]).to eq("Lunch")
      expect(json.first["menu_item_placements"].length).to eq(2)

      item_names = json.first["menu_item_placements"].map { |p| p["menu_item"]["name"] }
      expect(item_names).to include("Steak", "Salad")
    end
  end

  describe "GET /api/v1/menus/:id" do
    it "returns a specific menu with nested menu items" do
      get "/api/v1/menus/#{menu.id}"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["name"]).to eq("Lunch")
      expect(json["menu_item_placements"].length).to eq(2)
    end

    it "returns 404 if menu is not found" do
      get "/api/v1/menus/9999"

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Menu not found")
    end
  end
end
