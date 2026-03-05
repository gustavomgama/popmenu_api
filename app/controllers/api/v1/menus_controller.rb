class Api::V1::MenusController < ApplicationController
  def index
    menus = Menu.includes(:menu_items).all
    
    render json: menus.as_json(include: :menu_items)
  end

  def show
    menu = Menu.includes(:menu_items).find(params[:id])
    
    render json: menu.as_json(include: :menu_items)

  rescue ActiveRecord::RecordNotFound
    render json: { error: "Menu not found" }, status: :not_found
  end
end
