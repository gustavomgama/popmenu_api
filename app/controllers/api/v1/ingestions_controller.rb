class Api::V1::IngestionsController < ApplicationController
  def create
    service = Import::RestaurantDataService.new(params.to_unsafe_h)
    results = service.call

    render json: { results: }
  end
end
