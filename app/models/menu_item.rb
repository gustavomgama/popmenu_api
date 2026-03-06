class MenuItem < ApplicationRecord
  has_many :menu_item_placements, dependent: :destroy
  has_many :menus, through: :menu_item_placements

  validates :name, presence: true, uniqueness: true
end
