class CreateProductSymbols < ActiveRecord::Migration
  def change
    create_table :product_symbols do |t|
      t.integer :product_id
      t.integer :sacred_symbol_id
    end
  end
end
