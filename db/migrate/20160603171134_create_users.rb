class CreateUsers < ActiveRecord::Migration

  def change
    create_table :users do |t|
      t.integer :tribe_id, null: false, index: true
      t.string :email, null: false, index: true, limit: 64
      t.string :full_name, null: false, limit: 32
      t.string :title, limit: 64
      t.integer :manager_id, index: true
      t.integer :department_id, index: true
    end
  end
end
