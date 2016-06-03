class CreateGrants < ActiveRecord::Migration
  def change
    create_table :grants do |t|
      t.integer :granter_id, null: false
      t.integer :secondary_granter_id
      t.integer :grantee_id, null: false, index: true
      t.integer :competency_id, null: false
      t.timestamps
      t.text :reason
    end
  end
end
