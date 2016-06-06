class User < ActiveRecord::Base

  devise :omniauthable, :timeoutable, :authenticatable, omniauth_providers: [:google_oauth2]

  validates :email, :full_name, presence: true

  belongs_to :department
  belongs_to :manager, class_name: "User"

  has_many :competencies, through: :roles
  has_many :direct_reports, foreign_key: :manager_id, class_name: "User"
  has_many :received_grants, class_name: "Grant", foreign_key: :grantee_id
  has_many :roles, through: :user_roles  
  has_many :user_roles
  
  def self.from_omniauth(access_token)
    data = access_token.info
    User.where(email: data["email"]).first
  end

  def self.find_for_manager(manager, id)
    User.find(id).tap do |user|
      user_manager = user.manager
      while user_manager != manager
        raise ActiveRecord::RecordNotFound if user_manager.nil?
        user_manager = user_manager.manager
      end
    end
  end

  def update_roles(ids)
    ids ||= []
    role_ids = department.roles.where(id: ids).pluck(:id)
    all_role_ids = roles.pluck(:id)

    user_roles.where(role_id: all_role_ids - role_ids).delete_all
    (role_ids - all_role_ids).each{|r| user_roles.create!(role_id: r) }

  end

end
