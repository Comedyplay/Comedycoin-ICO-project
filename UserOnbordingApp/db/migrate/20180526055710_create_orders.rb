class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :address
      t.integer :amount
      t.integer :token
      t.time :time
      t.timestamps
    end
  end
end
