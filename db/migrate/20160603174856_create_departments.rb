class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.integer :tribe_id, null: false, index: true
      t.string :name, limit: 255
    end
  end
end
