class Inventoryadd < ActiveRecord::Migration
  def change
    create_table :inventory do |t|
      t.column :product_id, :int

      t.timestamps
    end
    rename_column :checkouts, :product_id, :inventory_id

  end


end
