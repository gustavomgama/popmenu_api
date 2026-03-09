require 'rails_helper'

module Import
  RSpec.describe RestaurantDataService do
    let(:sample_data) do
      {
        "restaurants" => [
          {
            "name" => "Test Cafe",
            "menus" => [
              {
                "name" => "Lunch",
                "dishes" => [
                  { "name" => "Burger", "price" => 10.0, "description" => "Yummy" },
                  { "name" => "Salad", "price" => 5.0, "description" => "Healthy" }
                ]
              }
            ]
          }
        ]
      }
    end

    subject { described_class.new(sample_data) }

    describe "#call" do
      it "creates a restaurant, menu, and items" do
        expect { subject.call }.to change(Restaurant, :count).by(1)
          .and change(Menu, :count).by(1)
          .and change(MenuItem, :count).by(2)
          .and change(MenuItemPlacement, :count).by(2)
      end

      it "is idempotent" do
        subject.call
        expect { subject.call }.not_to change(Restaurant, :count)
      end

      it "returns a summary with success status" do
        result = subject.call
        expect(result[:status]).to eq("success")
        expect(result[:total_processed]).to eq(2)
        expect(result[:results].first[:item]).to eq("Burger")
      end

      it "updates existing item descriptions" do
        create(:menu_item, name: "Burger", description: "Old")
        subject.call
        expect(MenuItem.find_by(name: "Burger").description).to eq("Yummy")
      end

      it "handles the key trap (dishes vs menu_items)" do
        alt_data = {
          "restaurants" => [ {
            "name" => "Alt",
            "menus" => [ {
              "name" => "M",
              "menu_items" => [ { "name" => "X", "price" => 1 } ]
            } ]
          } ]
        }
        service = described_class.new(alt_data)
        expect { service.call }.to change(MenuItem, :count).by(1)
      end
    end
  end
end
