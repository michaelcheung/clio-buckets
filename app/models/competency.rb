class Competency < ActiveRecord::Base

  validates :name, presence: true, length: { maximum: 255 }
  validates :category, length: { maximum: 32 }

  has_many :competency_roles
  has_many :roles, through: :competency_roles


end
