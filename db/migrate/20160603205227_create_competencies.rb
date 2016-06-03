class CreateCompetencies < ActiveRecord::Migration
  def change
    create_table :competencies do |t|
      t.string :category, null: false, limit: 16
      t.string :name, null: false, limit: 16
      t.integer :rank, null: false, default: 0
    end
    create_table :competency_roles do |t|
      t.integer :competency_id, null: false
      t.integer :role_id, null: false
    end
  end
end
