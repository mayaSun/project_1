class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name 
      t.text :description
      t.integer :price
      t.integer :stock
      t.integer :category_id
      t.string :image
      t.timestamps
    end
  end
end
