class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.boolean :fulfiled, default: false

      t.timestamps
    end
  end
end
