class AddUniqueIndexToMenuItemsName < ActiveRecord::Migration[8.1]
  def change
    add_index :menu_items, :name, unique: true
  end
end
