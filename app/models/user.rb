class User < ActiveRecord::Base

  validates :tribe_id, :email, :full_name, presence: true

  belongs_to :department, primary_key: :tribe_id
  belongs_to :manager, primary_key: :tribe_id, class_name: "User"

  has_many :employees, primary_key: :tribe_id, foreign_key: :manager_id, class_name: "User"
  

end
