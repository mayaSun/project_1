class CreateSacredSymbols < ActiveRecord::Migration
  def change
    create_table :sacred_symbols do |t|
      t.string :name
      t.string :image
      t.text :description
    end
  end
end
