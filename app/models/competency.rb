class Competency < ActiveRecord::Base

  validates :name, presence: true

  has_many :competency_roles
  has_many :roles, through: :competency_roles


end
