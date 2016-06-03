class User < ActiveRecord::Base

  devise :omniauthable, omniauth_providers: [:google_oauth2]

  validates :email, :full_name, presence: true

  belongs_to :department
  belongs_to :manager, class_name: "User"

  has_many :direct_reports, primary_key: :tribe_id, foreign_key: :manager_id, class_name: "User"

  has_many :competencies, through: :roles

  has_many :user_roles
  has_many :roles, through: :user_roles

  
  def self.from_omniauth(access_token)
    data = access_token.info
    User.where(email: data["email"]).first
  end

end
