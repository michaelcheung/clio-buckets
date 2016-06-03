class Department < ActiveRecord::Base

  validates :id, :name, presence: true

  has_many :roles
  has_many :users

end
