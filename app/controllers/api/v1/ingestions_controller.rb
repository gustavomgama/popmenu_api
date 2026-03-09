class Api::V1::IngestionsController < ApplicationController
  def create
    if params[:restaurants].present?
      ingestion_params = params.permit(
        restaurants: [
          :name,
          menus: [
            :name,
            :description,
            dishes: [ :name, :price, :description ],
            menu_items: [ :name, :price, :description ]
          ]
        ]
      ).to_h
    else
      ingestion_params = params.to_unsafe_h.slice("restaurants")
    end

    service = Import::RestaurantDataService.new(ingestion_params)
    results = service.call

    status = results[:status] == "error" ? :unprocessable_entity : :ok

    render json: results, status:
  end
end
