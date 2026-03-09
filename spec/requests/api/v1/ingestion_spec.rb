require 'rails_helper'

RSpec.describe "Api::V1::Ingestions", type: :request do
  describe "POST /api/v1/ingestions" do
    let(:valid_payload) do
      {
        restaurants: [
          {
            name: "Test",
            menus: [
              {
                name: "M",
                dishes: [ { name: "D", price: 10, description: "Desc" } ]
              }
            ]
          }
        ]
      }
    end

    it "returns success and the results log" do
      post "/api/v1/ingestions", params: valid_payload

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["status"]).to eq("success")
      expect(json["results"].first["item"]).to eq("D")
    end

    it "handles errors gracefully in the log" do
      invalid_payload = {
        restaurants: [ { name: "T", menus: [ { name: "M", dishes: [ { price: 10 } ] } ] } ]
      }

      post "/api/v1/ingestions", params: invalid_payload

      json = JSON.parse(response.body)
      expect(json["status"]).to eq("partial_success")
      expect(json["results"].first["status"]).to eq("error")
    end
  end
end
