class ApprovedFlagOnGrants < ActiveRecord::Migration

  def change
    change_table :grants do |t|
      t.boolean :approved, default: nil
    end
  end

end
