require 'rails_helper'

RSpec.describe "Api::V1::Menus", type: :request do
  let!(:menu) { create(:menu, name: "Menu") }
  let!(:menu_item1) { create(:menu_item, menu:, name: "Steak", price: 25) }
  let!(:menu_item2) { create(:menu_item, menu:, name: "Salad", price: 10) }

  describe "GET /api/v1/menus" do
    it "returns all menus with nested menu items" do
      get "/api/v1/menus"

      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(1)

      returned_menu = json_response.sole
      expect(returned_menu["name"]).to eq("Menu")
      expect(returned_menu["menu_items"].length).to eq(2)

      item_names = returned_menu["menu_items"].map { |item| item["name"] }
      expect(item_names).to include("Steak", "Salad")
    end
  end

  describe "GET /api/v1/menus/:id" do
    it "returns a specific menu with nested menu items" do
      get "/api/v1/menus/#{menu.id}"
      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(json_response["name"]).to eq("Menu")
      expect(json_response["menu_items"].length).to eq(2)
    end

    it "returns code 404 if menu is not found" do
      get "/api/v1/menus/1234"

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Menu not found")
    end
  end
end
