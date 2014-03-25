class Fixinv < ActiveRecord::Migration
  def change
    rename_table :inventory, :inventories
  end
end
