class Department < ActiveRecord::Base

  validates :tribe_id, :name, presence: true

  has_many :users, primary_key: :tribe_id

end
