class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :first_name
      t.string :last_name
      t.string :address_line1
      t.string :address_line2
      t.string :city
      t.string :country_code
      t.string :state_code
      t.string :postal_code
      t.string :phone_number
      t.string :email
      t.string :status
      t.integer :user_id
      t.string :reference_id
      t.string :confirmation_number
      t.string :tracking_number
      t.string :slug
      t.timestamps
    end
  end
end
