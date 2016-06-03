class CreatesRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.integer :department_id, null: false, index: true
      t.string :name, null: false, limit: 64
    end
  end
end
