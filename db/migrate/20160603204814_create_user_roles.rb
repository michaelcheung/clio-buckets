class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|
      t.integer :user_id, null: false, index: true
      t.integer :role_id, null: false, index: true
    end
  end
end
