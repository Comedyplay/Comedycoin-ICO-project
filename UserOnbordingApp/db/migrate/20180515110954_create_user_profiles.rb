class CreateUserProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :user_profiles do |t|
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.date :dob
      t.string :country
      t.string :phone_number
      t.string :building_number
      t.string :street_address
      t.string :city
      t.string :state
      t.string :country_address
      t.string :zip_code
      t.integer :user_id
      t.timestamps
    end
  end
end
