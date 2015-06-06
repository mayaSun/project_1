class AddSlugs < ActiveRecord::Migration
  def change
    add_column :users, :slug, :string
    add_column :products, :slug, :string
    add_column :categories, :slug, :string
    add_column :sacred_symbols, :slug, :string
  end
end
