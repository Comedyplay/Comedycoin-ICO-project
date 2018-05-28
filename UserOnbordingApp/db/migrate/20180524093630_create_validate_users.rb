class CreateValidateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :validate_users do |t|
      t.boolean :aggrement_verified
      t.boolean :identity_verified
      t.boolean :payment_verified
      t.boolean :confirmation_verified
      t.integer :user_id
      t.timestamps
    end
  end
end
