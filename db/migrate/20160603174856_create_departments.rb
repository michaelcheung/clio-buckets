class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name, limit: 255
    end
  end
end
