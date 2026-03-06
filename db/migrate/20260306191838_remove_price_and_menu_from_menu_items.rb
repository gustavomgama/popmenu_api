class RemovePriceAndMenuFromMenuItems < ActiveRecord::Migration[8.1]
  def change
    remove_column :menu_items, :price, :decimal
    remove_reference :menu_items, :menu, null: false, foreign_key: true
  end
end
