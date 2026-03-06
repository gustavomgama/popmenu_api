class Api::V1::RestaurantsController < ApplicationController
  def index
    restaurants = Restaurant.includes(menus: { menu_item_placements: :menu_item }).all

    render json: restaurants.as_json(
      include: {
        menus: {
          include: {
            menu_item_placements: {
              include: :menu_item
            }
          }
        }
      }
    )
  end

  def show
    restaurant = Restaurant.includes(menus: { menu_item_placements: :menu_item }).find(params[:id])

    render json: restaurant.as_json(
      include: {
        menus: {
          include: {
            menu_item_placements: {
              include: :menu_item
            }
          }
        }
      }
    )

  rescue ActiveRecord::RecordNotFound
    render json: { error: "Restaurant not found" }, status: :not_found
  end
end
