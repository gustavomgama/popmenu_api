class Api::V1::MenusController < ApplicationController
  def index
    menus = Menu.includes(menu_item_placements: :menu_item).all

    render json: menus.as_json(include: { menu_item_placements: { include: :menu_item } })
  end

  def show
    menu = Menu.includes(menu_item_placements: :menu_item).find(params[:id])

    render json: menu.as_json(include: { menu_item_placements: { include: :menu_item } })

  rescue ActiveRecord::RecordNotFound
    render json: { error: "Menu not found" }, status: :not_found
  end
end
