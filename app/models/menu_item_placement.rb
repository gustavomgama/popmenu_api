class MenuItemPlacement < ApplicationRecord
  belongs_to :menu
  belongs_to :menu_item

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :menu_item_id, uniqueness: { scope: :menu_id }

  def as_json(options = {})
    super(options).tap do |hash|
      hash["price"] = sprintf("%.2f", price) if price
    end
  end
end
