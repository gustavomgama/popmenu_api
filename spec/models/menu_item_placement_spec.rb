require 'rails_helper'

RSpec.describe MenuItemPlacement, type: :model do
  describe "associations" do
    it { should belong_to(:menu) }
    it { should belong_to(:menu_item) }
  end

  describe "validations" do
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }

    it "prevents menu item duplication on menu" do
      menu = create(:menu)
      menu_item = create(:menu_item)
      create(:menu_item_placement, menu: menu, menu_item: menu_item)

      duplicate = build(:menu_item_placement, menu: menu, menu_item: menu_item)
      expect(duplicate).not_to be_valid
    end
  end
end
