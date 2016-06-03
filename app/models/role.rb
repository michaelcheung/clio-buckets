class Role < ActiveRecord::Base

  validates :name, presence: true

  belongs_to :department

  has_many :competency_roles
  has_many :competencies, -> { uniq }, through: :competency_roles


  has_many :user_roles
  has_many :users, through: :user_roles  


end
