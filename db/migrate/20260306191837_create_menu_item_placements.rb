class CreateMenuItemPlacements < ActiveRecord::Migration[8.1]
  def change
    create_table :menu_item_placements do |t|
      t.references :menu, null: false, foreign_key: true
      t.references :menu_item, null: false, foreign_key: true
      t.decimal :price, precision: 10, scale: 2, null: false

      t.timestamps
    end

    add_index :menu_item_placements, [ :menu_id, :menu_item_id ], unique: true
  end
end
