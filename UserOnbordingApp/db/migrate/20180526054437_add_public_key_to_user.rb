class AddPublicKeyToUser < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :public_key, :string
  end
end
