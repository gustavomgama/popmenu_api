require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  describe "associations" do
    it { should have_many(:menu_item_placements).dependent(:destroy) }
    it { should have_many(:menus).through(:menu_item_placements) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  it "cannot be created with a duplicate name" do
    create(:menu_item, name: "Burger")
    duplicate = build(:menu_item, name: "Burger")
    expect(duplicate).not_to be_valid
  end
end
